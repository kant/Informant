//
//  SelectionHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-04.
//

import Foundation

class SelectionHelper {

	public enum SelectionType {
		case None
		case Single
		case Multi
		case Directory
		case Application
		case Image
		case Movie
		case Audio
	}

	public enum State {
		static let Unavailable = "Unavailable"
		static let Calculating = "Calculating..."
	}

	// MARK: - Utility Methods
	/// This function will take in a url string and provide a url resource values object which can be
	/// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	static func getURLResources(_ url: URL, _ keys: Set<URLResourceKey>) -> URLResourceValues? {
		do {
			return try url.resourceValues(forKeys: keys)
		}
		catch {
			return nil
		}
	}

	/// Used to grab the metadata for an image on a security scoped url
	static func getURLImageMetadata(_ url: URL) -> NSDictionary? {
		if let source = CGImageSourceCreateWithURL(url as CFURL, nil) {
			if let dictionary = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) {
				return dictionary as NSDictionary
			}
		}

		return nil
	}

	/// Used to grab all metadata for a movie on a security scoped url
	static func getURLMetadata(_ url: URL, keys: NSArray) -> [CFString: Any]? {
		if let mdItem = MDItemCreateWithURL(kCFAllocatorDefault, url as CFURL) {
			if let metadata = MDItemCopyAttributes(mdItem, keys) as? [CFString: Any] {
				return metadata
			}
		}

		return nil
	}

	// MARK: - Formatting Methods
	/// Formats the x & y dimensions of a media item into a universal format
	static func formatDimensions(x: Any?, y: Any?) -> String? {
		guard let pixelwidth = x as? Int else { return nil }
		guard let pixelheight = y as? Int else { return nil }

		let xStr = String(describing: pixelwidth)
		let yStr = String(describing: pixelheight)

		return xStr + " × " + yStr
	}

	/// Formats seconds into a DD:HH:MM:SS format (days, hours, minutes, seconds)
	static func formatDuration(_ duration: Any?) -> String? {
		guard let contentDuration = duration as? Double else { return nil }

		let interval = TimeInterval(contentDuration)

		// Setup formattter
		let formatter = DateComponentsFormatter()
		formatter.zeroFormattingBehavior = [.pad]

		// If the duration is under an hour then user a shorter formatter
		if contentDuration > 3599.0 {
			formatter.allowedUnits = [.hour, .minute, .second]
		}

		// Otherwise use the expanded one
		else {
			formatter.allowedUnits = [.minute, .second]
		}

		return formatter.string(from: interval)
	}

	/// Formats a raw hertz reading into hertz or kilohertz
	static func formatSampleRate(_ hertz: Any?) -> String? {
		guard let contentHertz = hertz as? Double else { return nil }

		// Format as hertz
		if contentHertz < 1000 {
			return String(format: "%.0f", contentHertz) + " Hz"
		}

		// Format as kilohertz
		else {
			let kHz = contentHertz / 1000
			return String(format: "%.1f", kHz) + " kHz"
		}
	}

	/// Formats raw byte size into a familliar 10MB, 3.2GB, etc.
	static func formatBytes(_ byteCount: Int64) -> String {
		return ByteCountFormatter().string(fromByteCount: byteCount)
	}

	// MARK: - Initialization Methods
	///	Determines the type of the selection and returns the appropriate object
	static func pickSelectionType(_ urls: [String]) -> SelectionProtocol? {

		// A multiselectitem if multiple items are selected
		if urls.count >= 2 {
			return MultiSelection(urls)
		}

		// Use some single selection init if only one item is selected
		else if urls.count == 1 {
			return pickSingleSelectionType(urls)
		}

		// Otherwise just link the reference to nil
		else {
			return nil
		}
	}

	/// Determines the type of content the selection is and returns the appropriate object
	static func pickSingleSelectionType(_ urls: [String]) -> SelectionProtocol? {

		let url = URL(fileURLWithPath: urls[0])

		// The resources we want to find
		let keys: Set<URLResourceKey> = [
			.typeIdentifierKey,
		]

		// All types that we're checking for
		let types = [
			kUTTypeImage,
			kUTTypeMovie,
			kUTTypeAudio,
			kUTTypeApplication,
			kUTTypeDirectory,
		]

		// Grabs the UTI type id and compares that to all the types we want to identify
		if let resources: URLResourceValues = getURLResources(url, keys) {

			// Cast the file's uniform type identifier
			let uti = resources.typeIdentifier! as CFString

			/// Stores the uti this selection conforms to
			var selectionType: CFString?

			// Cycle all the types and identify the file's type
			for type in types {
				if UTTypeConformsTo(uti, type) {
					selectionType = type
					break
				}
			}

			// Now that we have the uti, let's match it to the object we want to initialize
			switch selectionType {

				case kUTTypeImage: return SingleImageSelection(urls)

				case kUTTypeMovie: return SingleMovieSelection(urls)

				case kUTTypeAudio: return SingleAudioSelection(urls)

				case kUTTypeDirectory: return SingleDirectorySelection(urls)

				case kUTTypeApplication: return SingleApplicationSelection(urls)

				default: return SingleSelection(urls)
			}
		}

		return nil
	}
}

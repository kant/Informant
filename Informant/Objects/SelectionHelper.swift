//
//  SelectionHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-04.
//

import AVFoundation
import Foundation

class SelectionHelper {

	public enum SelectionType {
		case None
		case Error
		case Single
		case Multi
		case Directory
		case Application
		case Volume
		case Image
		case Movie
		case Audio
	}

	public enum State {

		case Unavailable
		case Finding
		case StopCalculating

		var localized: String {
			switch self {
				case .Unavailable:
					return ContentManager.State.unavailable
				case .Finding:
					return ContentManager.State.finding
				case .StopCalculating:
					return ContentManager.State.finished
			}
		}
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

	// MARK: - Metadata Methods

	/// Grabs videos resolution/dimensions using AVFoundation as opposed to kMDItemPixel...
	static func getMovieDimensions(url: URL) -> String? {
		guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
		let size = track.naturalSize.applying(track.preferredTransform)

		var width = size.width
		var height = size.height

		width.round(.towardZero)
		height.round(.towardZero)

		let widthRounded = Int(width)
		let heightRounded = Int(height)

		return SelectionHelper.formatDimensions(x: widthRounded, y: heightRounded)
	}

	// MARK: - Sizing Methods

	/// Checks if the file at the url is downloaded
	static func checkIsDownloaded(_ url: URL) -> Bool {
		if url.pathExtension != "icloud" {
			return true
		}
		else {
			return false
		}
	}

	/// Attempts to find the directory's size on a background thread, then commits changes found to the
	/// interface on the main thread. As well, it caches sizes found to reduce power consumption.
	///
	/// Threads are started but cannot be stopped. The only thing that we can prevent atm. is updating the interface.
	static func grabSize(_ url: URL, panelSelection: SingleSelection? = nil) {

		let appDelegate = AppDelegate.current()

		/// Updates the selection size for all interfaces. This function is nested so we have reference to the selection
		func updateInterfacesForSize(bytes: Int64?, state: State? = nil) {

			let sizeAsString: String?

			// Nil check the bytes
			if let bytes = bytes {
				sizeAsString = formatBytes(bytes)
			}

			// If no bytes are available, then report the state
			else if let state = state {
				sizeAsString = state.localized
			}

			// If nothing is available close the field
			else {
				sizeAsString = nil
			}

			// Update interfaces
			appDelegate.menubarInterfaceSelection?.itemSizeAsString = sizeAsString
			MenubarUtilityHelper.updateAndDisplayMenubarInterface()

			// Check to make sure interface data is present
			if let panelSelection = panelSelection {
				panelSelection.itemSizeAsString = sizeAsString
			}
		}

		// --------------- Function ⤵︎ ----------------

		let keys: Set<URLResourceKey> = [
			.isDirectoryKey,
			.isApplicationKey,
			.totalFileSizeKey,
			.isUbiquitousItemKey,
			.isVolumeKey,
		]

		// Get the url resources
		let itemResources = SelectionHelper.getURLResources(url, keys)

		let isDirectory = itemResources?.isDirectory

		let isVolume = itemResources?.isVolume

		let isiCloudSyncFile = itemResources?.isUbiquitousItem

		// Check if the current selection is a directory and if we should skip directories
		if (isDirectory == true && appDelegate.interfaceState.settingsPanelSkipDirectories) || isVolume == true {
			return updateInterfacesForSize(bytes: nil, state: nil)
		}

		// Check if the size is already cached, if so return that
		else if let cachedSize = url.getCachedByteSize() {
			return updateInterfacesForSize(bytes: Int64(cachedSize))
		}

		// Otherwise grab a new size
		else {

			// If the file is not downloaded then we don't show it's size
			if checkIsDownloaded(url) == false || (isDirectory == true && isiCloudSyncFile == true) {
				return updateInterfacesForSize(bytes: nil, state: nil)
			}

			// If it's a directory, find the size and update the
			else if isDirectory == true {

				// Let the users know we're calculating
				updateInterfacesForSize(bytes: nil, state: .Finding)

				// Check to make sure there are no work items on the queue
				if appDelegate.workQueue.count >= 1 {
					return
				}

				/// Holds the selection type in memory
				var type: SelectionType

				// Find type of selection
				if itemResources?.isApplication == true {
					type = .Application
				}
				else {
					type = .Directory
				}

				// ------------ Setup work blocks ⤵︎ --------------
				// Executes on the background
				appDelegate.workQueue.append(DispatchWorkItem {

					// Grab reference to the work item upon start of the execution
					guard let workItem = appDelegate.workQueue.last else {
						return
					}

					/// Holds raw size in memory
					var rawSize: Int64?

					// Grab directory size
					do {
						rawSize = try FileManager.default.allocatedSizeOfDirectory(at: url)
					}
					catch {
						rawSize = nil
					}

					// Make sure the work item wasn't cancelled. Otherwise we just don't update the interface as the op. is cancelled.
					// We can't stop the execution of the actual FileManager enumerator atm unfortunately.
					if workItem.isCancelled == false {

						// Update the user interface
						DispatchQueue.main.async {

							// Updates the interface when a size is found correctly
							if let size = rawSize {
								updateInterfacesForSize(bytes: size)
								url.storeByteSize(size, type: type)
							}

							// Otherwise let the users know we couldn't find a size
							else {
								updateInterfacesForSize(bytes: nil, state: .Unavailable)
								Debug.log("Size Unavailable", description: "Unable to find size for this item. Likely due to permissions.")
							}

							// Clean up execution
							appDelegate.workQueue.removeAll()
						}
					}
				})

				// We grab the last work queue item because it's the most current
				if let workItem = appDelegate.workQueue.last {
					DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.1, execute: workItem)
				}
			}

			// Otherwise just return a normal size
			else if let totalSize = itemResources?.totalFileSize {
				return updateInterfacesForSize(bytes: Int64(totalSize))
			}

			// If everything fails just return nil
			return
		}
	}

	// MARK: - Formatting Methods

	/// Takes in a directory item count and formats it accordingly
	static func formatDirectoryItemCount(_ itemCount: Int) -> String {
		return String(itemCount) + " " + (itemCount > 1 ? ContentManager.Extra.items : ContentManager.Extra.item)
	}

	/// Checks the url and settings and decides if the full url should be shown
	static func formatPathBasedOnSettings(_ url: URL) -> String? {

		// Check if the user wants to see where the file is located or the full path length
		if AppDelegate.current().interfaceState.settingsPanelDisplayFullPath == false {
			let shortenedURL = url.deletingLastPathComponent()
			return SelectionHelper.formatPathTildeAbbreviate(shortenedURL.path)
		}

		// Otherwise show the full path
		else {
			return SelectionHelper.formatPathTildeAbbreviate(url.path)
		}
	}

	/// Modifies the root directory of the path to a ~
	static func formatPathTildeAbbreviate(_ path: String?) -> String? {

		guard let homeDirectoryVolume = FileManager.default.getRealHomeDirectory else {
			return nil
		}

		// We need to figure out if the path includes the /Volumes/ directory
		if path?.contains(homeDirectoryVolume) == true {
			return path?.replacingOccurrences(of: homeDirectoryVolume, with: "~")
		}

		// Otherwise just pull the home directory
		else {

			guard let homeDirectory = FileManager.default.getHomeDirectory else {
				return nil
			}

			return path?.replacingOccurrences(of: homeDirectory, with: "~")
		}
	}

	/// Shortens the path by completely removing the root (/Volumes/Macintosh HD/) of the path
	static func shortenPath(_ path: String) -> String? {
		guard let rootVolume = FileManager.default.getRootVolumeAsPath else {
			return nil
		}

		return path.replacingOccurrences(of: rootVolume, with: "")
	}

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

		// Round duration by casting to int
		let roundedDuration = contentDuration.rounded(.toNearestOrAwayFromZero)

		let interval = TimeInterval(roundedDuration)

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

	enum DataSizeUnit {
		case None
		case Kb
		case Mb
	}

	/// Formats raw byte size into kbps
	static func formatBitrate(_ bitCount: Int64, unit: DataSizeUnit = .Kb) -> String? {

		let bits = Double(bitCount)

		let formattedBits: NSNumber
		let unitDescription: String

		switch unit {

			case .None:
				formattedBits = NSNumber(value: bits)
				unitDescription = "Kbps"
				break

			case .Kb:
				formattedBits = NSNumber(value: bits / 1000.0)
				unitDescription = "Kbps"
				break

			case .Mb:
				formattedBits = NSNumber(value: bits / 10000.0)
				unitDescription = "Mbps"
				break
		}

		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3

		guard let bitsPerSecond = formatter.string(from: formattedBits) else {
			return nil
		}

		return "\(bitsPerSecond) \(unitDescription)"
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
	static func pickSingleSelectionType(_ urls: [String], parameters: [SelectionParameters] = [.grabSize]) -> SelectionProtocol? {

		let url: URL
		let path = urls[0]

		// Make sure the selection is not empty
		if path.isEmpty {
			return nil
		}

		// Finds the root volume path and removes it in order to get a volume selection. For some reason a normal volume path with the root drive isn't accepted.
		guard let rootDrivePath = FileManager.default.getRootVolumeAsPath else {
			return nil
		}

		if path == rootDrivePath {
			url = URL(fileURLWithPath: "/")
		}

		// Otherwise the url is assigned normally
		else {
			url = URL(fileURLWithPath: path)
		}

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
			kUTTypeVolume,
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

				case kUTTypeImage: return SingleImageSelection(urls, parameters: parameters)

				case kUTTypeMovie: return SingleMovieSelection(urls, parameters: parameters)

				case kUTTypeAudio: return SingleAudioSelection(urls, parameters: parameters)

				case kUTTypeDirectory: return SingleDirectorySelection(urls, parameters: parameters)

				case kUTTypeApplication: return SingleApplicationSelection(urls, parameters: parameters)

				case kUTTypeVolume: return SingleVolumeSelection(urls, parameters: parameters)

				default: return SingleSelection(urls, parameters: parameters)
			}
		}

		return nil
	}
}

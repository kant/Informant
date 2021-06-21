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
	}

	public enum State {
		static let Unavailable = "Unavailable"
		static let Calculating = "Calculating"
	}

	// MARK: - Methods
	// This function will take in a url string and provide a url resource values object which can be
	// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	static func getURLResources(_ url: URL, _ keys: Set<URLResourceKey>) -> URLResourceValues? {
		do {
			return try url.resourceValues(forKeys: keys)
		}
		catch {
			return nil
		}
	}

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
			kUTTypeDirectory,
			kUTTypeApplication,
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

				case kUTTypeImage: return SingleSelection(urls)

				case kUTTypeMovie: return SingleSelection(urls)

				case kUTTypeAudio: return SingleSelection(urls)

				case kUTTypeDirectory: return SingleSelection(urls)

				case kUTTypeApplication: return SingleSelection(urls)

				default: return SingleSelection(urls)
			}
		}

		return nil
	}
}

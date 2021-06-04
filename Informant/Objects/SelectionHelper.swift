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

	// MARK: - Methods
	// This function will take in a url string and provide a url resource values object which can be
	// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	func getURLResources(_ url: URL, _ keys: Set<URLResourceKey>) -> URLResourceValues? {
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
			return SingleSelection(urls)
		}

		// Otherwise just link the reference to nil
		else {
			return nil
		}
	}
}

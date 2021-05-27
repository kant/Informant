//
//  SelectedItemCollection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Foundation

// MARK: - Used for storing multiple files
@available(*, renamed: "Selection", message: "This name is more specific because this data won't just be used for the interface.")
class Selection: ObservableObject {

	public enum CollectionType {
		case Single
		case Multi
		case Directory
	}

	@Published public var selectItem = SelectItem()
	public let collectionType: CollectionType?

	init?(_ urls: [String]? = nil) {

		// Check to see if the urls object is nil or not
		guard let filePaths = urls else {
			return nil
		}

		// Use a singleselectitem if only one item is selected
		if filePaths.count == 1 {
			selectItem = SingleSelectItem(urls: filePaths)
			collectionType = .Single
		}

		// and a multiselectitem if multiple items are selected
		else if filePaths.count >= 2 {
			selectItem = MultiSelectItem(urls: filePaths)
			collectionType = .Multi
		}

		// Otherwise just link the reference to nil
		else {
			return nil
		}
	}

	/// Checks to make sure that all data is valid
	public func isNotNil(_ selection: Selection?) -> Bool {
		if selection == nil || selection?.selectItem.title == nil {
			return false
		}
		else {
			return true
		}
	}
}

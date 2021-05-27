//
//  SelectedItemCollection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Foundation

// MARK: - Used for storing multiple files
class ItemCollection: ObservableObject {

	public enum CollectionType {
		case Single
		case Multi
		case Directory
	}

	@Published public var selectItem = SelectItem()
	public let collectionType: CollectionType?

	init?(filePaths: [String]) {

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
}

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

	@Published public var files: [SelectItem] = []
	@Published public var summary: SelectItem?
	public let collectionType: CollectionType?

	// Use a singleselectitem if only one item is selected and a multiselectitem if multiple items are selected
	init(collectionType: CollectionType, filePaths: [String]) {
		self.collectionType = collectionType

		for path in filePaths {
			files.append(SingleSelectItem(url: path))
		}
	}
}

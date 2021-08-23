//
//  SelectedItemCollection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Foundation

// MARK: - Used for storing multiple files

/// Used by the app delegate as a global interface data filler
class InterfaceData: ObservableObject {

	@Published public var selection: SelectionProtocol?

	private(set) var urls: [String]?

	init?(_ urls: [String]? = nil, error: Bool? = nil) {

		// Check to make sure there are no errors first
		if error == true {
			selection = SingleErrorSelection()
			return
		}

		// Check to see if the urls object is nil or not
		guard let filePaths = urls else {
			return nil
		}

		// Sets urls after being nil checked
		self.urls = filePaths

		// Provide the nil checked pathes to the SelectItem object
		selection = SelectionHelper.pickSelectionType(filePaths)
	}
}

/// Used to simply have an optional in an observable
class InterfaceDataWrapper: ObservableObject {
	@Published public var data: InterfaceData?

	init(data: InterfaceData?) {
		self.data = data
	}
}

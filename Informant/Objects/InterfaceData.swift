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

	init?(_ urls: [String]? = nil) {

		// Check to see if the urls object is nil or not
		guard let filePaths = urls else {
			return nil
		}

		// Provide the nil checked pathes to the SelectItem object
		selection = SelectionHelper.pickSelectionType(filePaths)
	}
}

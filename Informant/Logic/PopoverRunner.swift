//
//  FinderBridge.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Foundation
import SwiftUI

// MARK: - File Helper
// This class is used to return a data set for use by the interface. It's dependent on the selection
// made by the user

class PopoverRunner {

	// This grabs the currently selected Finder item(s) and then executes the corresponding logic
	// based on the Finder items selected.
	public static func Dispatcher() -> ItemCollection? {

		let selectedFiles: [String] = AppleScripts.findSelectedFiles()

		// Block executed if only one file is selected
		if selectedFiles.count <= 1 {
			return ItemCollection(collectionType: .Single, filePaths: selectedFiles)
		}

		return nil
	}

	// Display popover with selected items
	public static func Display() {
	}
}

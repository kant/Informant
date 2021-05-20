//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Foundation
import SwiftUI

// MARK: - File Helper
// This class is used to return a data set for use by the interface. It's dependent on the selection
// made by the user
class InterfaceHelper {

	// This grabs the currently selected Finder item(s) and then executes the corresponding logic
	// based on the Finder items selected.
	public static func GetFinderSelection() -> ItemCollection? {

		let selectedFiles: [String] = AppleScripts.findSelectedFiles()

		// Block executed if only one file is selected
		if selectedFiles.count <= 1 {
			return ItemCollection(collectionType: .Single, filePaths: selectedFiles)
		}

		return nil
	}

	// Display interface with selected items
	public static func DisplayUpdatedInterface(appDelegate: AppDelegate) {

		// Check to make sure a file is selected before executing logic
		let selectedItems: ItemCollection? = InterfaceHelper.GetFinderSelection()

		if selectedItems != nil {
			// Find selected files
			appDelegate.interfaceData.fileCollection = selectedItems
			appDelegate.contentView.interfaceData = appDelegate.interfaceData

			// Update popover after hotkey press
			appDelegate.UpdateInterface(interfaceData: appDelegate.interfaceData)
		}
	}

	// Runs toggle on window. Typically called by activation shortcut
	public static func ToggleInterface(appDelegate: AppDelegate) {

		// Toggles window closed if it's already active
		if appDelegate.window.isVisible {
			appDelegate.statusBar?.toggleWindow()
			return
		}

		appDelegate.statusBar?.toggleWindow()

		// TODO: Make sure finder gets activated on the appropriate screen and not just the first one
		// Set Finder to be the front most application
//		NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder")[0].activate()
	}
}

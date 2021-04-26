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

class PopoverHelper {

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
	public static func DisplayToggle(appDelegate: AppDelegate) {

		// Toggle's popover closed if it's already active
		if appDelegate.popover.isShown {
			appDelegate.statusBar?.togglePopover(sender: appDelegate.popover)
			return
		}

		// Check to make sure a file is selected before executing logic
		let dispatcherFiles: ItemCollection? = PopoverHelper.Dispatcher()

		if dispatcherFiles != nil {
			// Find selected files
			appDelegate.interfaceData.fileCollection = dispatcherFiles
			appDelegate.contentView.interfaceData = appDelegate.interfaceData

			// Update popover after hotkey press
			appDelegate.updatePopover(interfaceData: appDelegate.interfaceData)
		}

		// Toggle open popover
		appDelegate.statusBar?.togglePopover(sender: appDelegate.popover)

		// Set Finder to be the front most application
		NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder")[0].activate()
	}
}

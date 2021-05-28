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
	public static func GetFinderSelection() -> Selection? {

		guard let selectedFiles: [String] = AppleScripts.findSelectedFiles() else {
			return nil
		}

		// Block executed if only one file is selected
		if selectedFiles.count >= 1 {
			return Selection(selectedFiles)
		}

		return nil
	}

	// Display interface with selected items
	public static func DisplayUpdatedInterface() {

		// Grab current app delegate
		let appDelegate = AppDelegate.current()

		// Check to make sure a file is selected before executing logic
		let selectedItems: Selection? = InterfaceHelper.GetFinderSelection()

		// Find selected files
		appDelegate.interfaceData = selectedItems
		appDelegate.contentView.interfaceData = appDelegate.interfaceData

		// Update popover after hotkey press
		UpdateInterface()
	}

	// Update the popover's view
	public static func UpdateInterface() {

		// Grab app delegate
		let appDelegate = AppDelegate.current()

		// Make the window resizeable while the interface gets updated
		appDelegate.window.styleMask.insert(.resizable)

		// Create the SwiftUI view that provides the panel contents.
		appDelegate.contentView = ContentView(appDelegate)

		// Set the SwiftUI view to the panel view
		appDelegate.window.contentViewController = NSHostingController(rootView: appDelegate.contentView)

		// Remove the ability to resize the window
		appDelegate.window.styleMask.remove(.resizable)
	}

	/// Generic function to run toggle
	static func ToggleInterface(toggleMethod: StatusBarController.ToggleMethod) {

		// Grab the app delegate
		let appDelegate = AppDelegate.current()

		// Toggle the interface
		appDelegate.statusBarController?.toggleWindow(toggleMethod: toggleMethod)
	}

	/// Runs toggle on panel. Typically called by activation shortcut
	public static func ToggleInterfaceByKey() {
		ToggleInterface(toggleMethod: .Key)
	}

	/// Runs toggle on panel. This however is used when activating via the Status Item Button
	public static func ToggleInterfaceByClick() {
		ToggleInterface(toggleMethod: .Click)
	}
}

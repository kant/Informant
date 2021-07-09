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

	/// Used to keep track of the previous selection. It makes sure that we don't make duplicate updates to the interface.
	private var selectionInMemory: [String]?

	/// Resets the state of the interface helper
	public func ResetState() {
		selectionInMemory = nil
	}

	// This grabs the currently selected Finder item(s) and then executes the corresponding logic
	// based on the Finder items selected.
	func GetFinderSelection() -> CheckedSelection? {

		// Grab appDelegate first
		let appDelegate = AppDelegate.current()

		// Store the selection into memory
		guard let selection = AppleScriptsHelper.findSelectedFiles() else {
			return nil
		}

		// Check for errors first, if found, restart memory state
		if selection.error == true {
			ResetState()
			return CheckedSelection(selection, state: .errorSelection)
		}

		// Get the selected files
		guard let paths: [String] = selection.paths else {
			return nil
		}

		// Make sure the selection is not a duplicate
		if selectionInMemory == paths {
			return CheckedSelection(selection, state: .duplicateSelection)
		} else {
			selectionInMemory = paths
		}

		// Cancel all background tasks
		if let blocks = appDelegate.interfaceData?.selection?.workQueue {
			for block in blocks {
				block.cancel()
			}

			appDelegate.securityBookmarkHelper.stopAccessingRootURL()
		}

		// Block executed if only one file is selected
		if paths.count >= 1 {
			return CheckedSelection(selection, state: .uniqueSelection)
		}

		return nil
	}

	/// This takes account for the selection and returns the correct interface data
	static func GetInterfaceData() -> InterfaceData? {

		// Get the selection
		guard let checkedSelection = AppDelegate.current().panelInterfaceHelper.GetFinderSelection() else {
			return nil
		}

		switch checkedSelection.state {

		case .errorSelection: return InterfaceData(nil, error: true)

		case .duplicateSelection: return AppDelegate.current().interfaceData

		case .uniqueSelection: return InterfaceData(checkedSelection.selection.paths, error: false)
		}
	}

	// Display interface with selected items
	public static func DisplayUpdatedInterface() {

		// Grab current app delegate
		let appDelegate = AppDelegate.current()

		// Check to make sure a file is selected before executing logic
		let selectedItems: InterfaceData? = InterfaceHelper.GetInterfaceData()

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
		appDelegate.panel.styleMask.insert(.resizable)

		// Create the SwiftUI view that provides the panel contents.
		appDelegate.contentView = ContentView()

		// Set the SwiftUI view to the panel view
		appDelegate.panel.contentViewController = NSHostingController(rootView: appDelegate.contentView)

		// Remove the ability to resize the window
		appDelegate.panel.styleMask.remove(.resizable)
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

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

	/// Resets all instances of the interface helper
	static func ResetAllStates() {
		let appDelegate = AppDelegate.current()
		appDelegate.panelInterfaceHelper.ResetState()
		appDelegate.menubarInterfaceHelper.ResetState()
	}

	// This grabs the currently selected Finder item(s) and then executes the corresponding logic
	// based on the Finder items selected.
	func GetFinderSelection(force: Bool = false) -> CheckedSelection? {

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

		// Make sure it's not a forced selection
		if force {
			return CheckedSelection(selection, state: .uniqueSelection)
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
		for block in appDelegate.workQueue {
			block.cancel()
		}

		// Clean up execution
		appDelegate.securityBookmarkHelper.stopAccessingRootURL()
		appDelegate.workQueue.removeAll()

		// Block executed if only one file is selected
		if paths.count >= 1 {
			return CheckedSelection(selection, state: .uniqueSelection)
		}

		return nil
	}

	/// This takes account for the selection and returns the correct interface data
	static func GetInterfaceData(force: Bool = false) -> InterfaceData? {

		// Get the selection
		guard let checkedSelection = AppDelegate.current().panelInterfaceHelper.GetFinderSelection(force: force) else {
			return nil
		}

		switch checkedSelection.state {

		case .errorSelection: return InterfaceData(nil, error: true)

		case .duplicateSelection: return AppDelegate.current().interfaceData

		case .uniqueSelection: return InterfaceData(checkedSelection.selection.paths, error: false)
		}
	}

	// Display interface with selected items
	public static func DisplayUpdatedInterface(force: Bool = false) {

		// Grab current app delegate
		let appDelegate = AppDelegate.current()

		// Check accessibility
		if appDelegate.interfaceState.privacyAccessibilityEnabled == true {

			// Check to make sure a file is selected before executing logic
			let selectedItems: InterfaceData? = InterfaceHelper.GetInterfaceData(force: force)

			// Find selected files
			appDelegate.interfaceData = selectedItems
			appDelegate.contentView.interfaceData.data = appDelegate.interfaceData
		}
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

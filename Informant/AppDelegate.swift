//
//  AppDelegate.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Cocoa
import FinderSync
import KeyboardShortcuts
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	// This is the actual popover object that is created on app init
	var popover = NSPopover()

	// We use this status bar object to make managing the popover a lot easier
	var statusBar: StatusBarController?

	// This contians all data needed for the interface
	var interfaceData = InterfaceData()
	var contentView = ContentView()

	// Initialization for the application
	override init() {
		popover.animates = false
	}

	// Update the popover's view
	func updatePopover(interfaceData: InterfaceData) {
		// Create the SwiftUI view that provides the window contents.
		contentView = ContentView(interfaceData: interfaceData)

		// Set the SwiftUI view to the popover view
		popover.contentSize = NSSize(width: 290, height: 300)
		popover.contentViewController = NSHostingController(rootView: contentView)
	}

	// ------------------ Main Program ⤵︎ ------------------

	func applicationDidFinishLaunching(_: Notification) {
		// Update the popover on initialization
		updatePopover(interfaceData: interfaceData)

		// Initialize status bar
		statusBar = StatusBarController(popover)

		// Keyboard shortcuts
		KeyboardShortcuts.onKeyUp(for: .togglePopover) { [self] in

			if popover.isShown {
				// Toggle open popover
				statusBar?.togglePopover(sender: popover)
				return
			}

			// Check to make sure a file is selected before executing logic
			let dispatcherFiles: ItemCollection? = FinderBridge.Dispatcher()

			if dispatcherFiles != nil {
				// Find selected files
				interfaceData.fileCollection = dispatcherFiles
				contentView.interfaceData = interfaceData

				// Update popover after hotkey press
				updatePopover(interfaceData: interfaceData)
			}

			// Toggle open popover
			statusBar?.togglePopover(sender: popover)
		}
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}

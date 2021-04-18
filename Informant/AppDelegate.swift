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

	func applicationDidFinishLaunching(_: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let collection: FileCollection? = FinderBridge.Dispatcher()
		var contentView = ContentView(files: collection!)

		// Set the SwiftUI view to the popover view
		popover.contentSize = NSSize(width: 360, height: 360)
		popover.contentViewController = NSHostingController(rootView: contentView)

		// Initialize status bar
		statusBar = StatusBarController(popover)

		// Keyboard shortcuts
		KeyboardShortcuts.onKeyUp(for: .togglePopover) { [self] in
			let collection: FileCollection? = FinderBridge.Dispatcher()

			contentView.files = collection!

			print(collection!.files[0].fileName!)

			statusBar?.togglePopover(sender: popover)
		}
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}

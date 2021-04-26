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
	public var popover = NSPopover()

	// We use this status bar object to make managing the popover a lot easier
	public var statusBar: StatusBarController?

	// This contians all data needed for the interface
	public var interfaceData = InterfaceData()
	public var contentView = ContentView()

	// Initialization for the application
	override init() {
		popover.animates = false
	}

	// Update the popover's view
	public func updatePopover(interfaceData: InterfaceData) {
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

		// MARK: - Keyboard Shortcuts
		KeyboardShortcuts.onKeyUp(for: .togglePopover) { [self] in
			PopoverHelper.DisplayToggle(appDelegate: self)
		}
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}

//
//  AppDelegate.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import KeyboardShortcuts
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	// This is the actual popover object that is created on app init
	public var window: NSPanel!

	// We use this status bar object to make managing the popover a lot easier
	public var statusBarController: StatusBarController?

	// This contians all data needed for the interface
	public var interfaceData = InterfaceData()
	public var contentView = ContentView()

	// ------------------ Main Program ⤵︎ ------------------

	func applicationDidFinishLaunching(_: Notification) {

		// MARK: - Privacy Init

		// TODO: Clean up this section - it asks for accessiblity permissions
		let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
		let accessEnabled = AXIsProcessTrustedWithOptions(options)

		// A simple error message if access is not enabled
		if !accessEnabled {
			print("Access Not Enabled")
		}

		// MARK: - Window Init

		// TODO: Clean up these window actions
		/// This is the main interface used by the application
		window = NSPanel(
			contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
			styleMask: [.resizable, .fullSizeContentView, .nonactivatingPanel, .borderless],
			backing: .buffered, defer: false)

		// TODO: This needs to be adjusted so that it's actually in the center
		// Centers window in middle of screen on launch
		window.center()

		// Brings window to the top level but not above the menubar
		window.level = .floating
		window.becomesKeyOnlyIfNeeded = true

		// Nice smooth exit
		window.animationBehavior = .utilityWindow

		// Other self explained window settings
		window.isOpaque = false
		window.backgroundColor = .clear
		window.isMovableByWindowBackground = true

		// TODO: Deprecate, I don't believe this is necessary
		// Makes sure that the window can be reopened after being closed
		window.isReleasedWhenClosed = false

		// Set the view controller
		window.contentViewController = NSHostingController(rootView: contentView)

		// MARK: - App Init

		// Update the interface on initialization
		InterfaceHelper.UpdateInterface()

		// Initialize status bar
		statusBarController = StatusBarController()

		// MARK: - Keyboard Shortcuts

		// This shortcut is for activation of the interface
		KeyboardShortcuts.onKeyUp(for: .togglePopover) {
			InterfaceHelper.ToggleInterfaceByKey()
		}

		// MARK: - Notifications

		/**

		 NotificationCenter.default.addObserver(forName: .init("NSWindowDidResignKeyNotification"), object: nil, queue: nil) { _ in
		 	print("This window became unfocused")
		 }

		 NotificationCenter.default.addObserver(forName: .init("NSWindowDidBecomeKeyNotification"), object: nil, queue: nil) { _ in
		 	print("This window became focused")
		 }

		 */
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}

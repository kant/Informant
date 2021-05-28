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

	/// This is the panel interface
	public var window: NSPanel!

	/// We use this status bar object to make managing the popover a lot easier.
	public var statusBarController: StatusBarController?

	/// Controls the interface panel menu
	public var interfaceMenuController: InterfaceMenuController?

	/// This is the menu on the interface panel accessed by the gear icon
	public var interfaceMenu: NSMenu!

	/// This contians all data needed for the interface.
	public var interfaceData = Selection()

	/// The view for the interface.
	public var contentView: ContentView!

	// ------------------ Main Program ⤵︎ ------------------

	func applicationDidFinishLaunching(_: Notification) {

		// MARK: - Content View Init

		contentView = ContentView(self)

		// MARK: - Privacy Init

		// TODO: Clean up this section - it asks for accessiblity permissions
		let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
		let accessEnabled = AXIsProcessTrustedWithOptions(options)

		// A simple error message if access is not enabled
		if !accessEnabled {
			print(ContentManager.Messages.setupAccessibilityNotEnabled)
		}

		// MARK: - Menu Init

		interfaceMenu = NSMenu()

		// Initializes the menu for the panel interface
		interfaceMenuController = InterfaceMenuController()

		// MARK: - Window Init

		/// This is the main interface used by the application
		window = NSPanel(
			contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
			styleMask: [.resizable, .fullSizeContentView, .nonactivatingPanel, .borderless],
			backing: .buffered, defer: false
		)

		// TODO: This needs to be adjusted so that it's actually in the center
		// Centers window in middle of screen on launch
		window.center()

		// Brings window to the top level but not above the menubar
		window.level = .floating
		window.becomesKeyOnlyIfNeeded = true

		// Nice smooth exit
		window.animationBehavior = .none

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

		// Toggle the interface when the user switches virtual desktops
		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(notifyStatusBarControllerSpaceChanged),
			name: NSWorkspace.activeSpaceDidChangeNotification,
			object: nil
		)
	}

	/// Lets the status bar controller know that the active space has changed
	@objc func notifyStatusBarControllerSpaceChanged() {
		statusBarController?.setSpaceDidChange()
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}

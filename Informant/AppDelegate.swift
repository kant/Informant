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
	public var panel: NSPanel!

	/// We use this status bar object to make managing the popover a lot easier.
	public var statusBarController: StatusBarController?

	/// We use this to access the menubar status item
	public var statusItem: NSStatusItem!

	// MARK: - Interface
	/// Controls the interface panel menu
	public var interfaceMenuController: InterfaceMenuController?

	/// This is the menu on the interface panel accessed by the gear icon
	public var interfaceMenu: NSMenu!

	/// This is the controller for the alert view
	public var interfaceAlertController: InterfaceAlertController?

	/// This is an alert akin to the Xcode 'Build Succeeded' alert
	public var interfaceAlert: NSPanel!

	/// This is the close button for the window
	public var interfaceClose: NSPanel!

	/// This is the controller for the close button
	public var interfaceCloseController: InterfaceCloseController?

	/// This contians all data needed for the interface.
	public var interfaceData: InterfaceData!

	/// This contains all the settings data needed for the application
	public var interfaceState: InterfaceState!

	// MARK: - Interface Helpers
	public var panelInterfaceHelper = InterfaceHelper()
	public var menubarInterfaceHelper = InterfaceHelper()

	// MARK: - Settings
	/// This is the window that displays all settings to the user
	public var settingsWindow: NSInformantWindow!

	/// This sets up and controls the settings window's state
	public var settingsWindowController: SettingsWindowController!

	/// This sets up and controls the welcome window
	public var welcomeWindowController: WelcomeWindowController!

	/// This is the welcome window that's presented when the user first starts the application
	public var welcomeWindow: NSInformantWindow!

	// MARK: - Extra
	/// This helps work out the security scoping issue
	public var securityBookmarkHelper: SecurityBookmarkHelper!

	/// This keeps tracks of any items that need to be cached for later use
	public var cache: Cache!

	/// The view for the interface.
	public var contentView: ContentView!

	// ------------------ Main Program ⤵︎ ------------------

	func applicationDidFinishLaunching(_: Notification) {

		// MARK: - Settings Init

		registerUserDefaults()

		// MARK: - App initialization

		securityBookmarkHelper = SecurityBookmarkHelper()

		interfaceData = InterfaceData()

		interfaceState = InterfaceState()

		contentView = ContentView()

		cache = Cache()

//		// MARK: - Privacy Init
//
//		// Check accssibility authorization. Reminder: This only shows up with no sandbox or a distribution profile
//		interfaceState.privacyAccessibilityEnabled = AXIsProcessTrusted()

		// MARK: - Menu Init

		interfaceMenu = NSMenu()

		// Initializes the menu for the panel interface
		interfaceMenuController = InterfaceMenuController()

		// MARK: - Alert Init

		interfaceAlert = NSPanel(
			contentRect: NSRect(x: 0, y: 0, width: 210, height: 210),
			styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel],
			backing: .buffered, defer: false
		)

		// Initialized the interface alert panel
		interfaceAlertController = InterfaceAlertController()

		// MARK: - Window Init

		/// This is the main interface used by the application
		panel = NSPanel(
			contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
			styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel, .borderless],
			backing: .buffered, defer: false
		)

		// TODO: This needs to be adjusted so that it's actually in the center
		// Centers window in middle of screen on launch
		panel.center()

		// Hide the titlebar
		panel.titlebarAppearsTransparent = true
		panel.titleVisibility = .hidden

		// Hide all Titlebar Controls
		panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
		panel.standardWindowButton(.closeButton)?.isHidden = true
		panel.standardWindowButton(.zoomButton)?.isHidden = true

		// Brings window to the top level but not above the menubar
		panel.level = .floating
		panel.becomesKeyOnlyIfNeeded = true

		// Nice smooth exit
		panel.animationBehavior = .none

		// Other self explained window settings
		panel.isMovableByWindowBackground = true

		// TODO: Deprecate, I don't believe this is necessary
		// Makes sure that the window can be reopened after being closed
		panel.isReleasedWhenClosed = false

		// Set the view controller
		panel.contentViewController = NSHostingController(rootView: contentView)

		// MARK: - Close Init

		interfaceClose = NSPanel(
			contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
			styleMask: [.fullSizeContentView, .nonactivatingPanel],
			backing: .buffered,
			defer: false
		)

		// Sets up the close button (positions, sets up view, etc.)
		interfaceCloseController = InterfaceCloseController(interfaceClose)

		// MARK: - Settings Init

		settingsWindow = NSInformantWindow(
			contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
			styleMask: [.fullSizeContentView, .closable, .titled, .miniaturizable, .unifiedTitleAndToolbar],
			backing: .buffered,
			defer: false
		)

		// Setup the settings window
		if let settingsWindow = settingsWindow {
			settingsWindowController = SettingsWindowController(settingsWindow)
		}

		// MARK: - Welcome Init

		welcomeWindow = NSInformantWindow(
			contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
			styleMask: [.fullSizeContentView, .closable, .titled, .unifiedTitleAndToolbar],
			backing: .buffered,
			defer: false
		)

		// Setup the welcome window
		if let welcomeWindow = welcomeWindow {
			welcomeWindowController = WelcomeWindowController(welcomeWindow)
		}

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

		// Observes movement of window and sets it's opacity and position accordingly
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didMove),
			name: NSPanel.didMoveNotification,
			object: panel
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(willMove),
			name: NSPanel.willMoveNotification,
			object: panel
		)

		/// https://stackoverflow.com/a/56206516/13142325
		DistributedNotificationCenter.default().addObserver(
			forName: NSNotification.Name("com.apple.accessibility.api"),
			object: nil,
			queue: nil
		) { _ in
			self.didAccessibilityChange()
		}
	}

	// Insert code here to tear down your application
	func applicationWillTerminate(_: Notification) {

		// Stop listening to mouse
		statusBarController?.monitorMouseDismiss?.stop()

		// Stop listening to the keyboard
		statusBarController?.monitorKeyPress?.stop()
	}

	// --- Selectors for sys. pref. changes ⤵︎ ---

	@objc func didAccessibilityChange() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.interfaceState.privacyAccessibilityEnabled = AXIsProcessTrusted()
			self.statusBarController?.updateInterfaces()
		}
	}

	// --- Selectors for the panel movement notifications ⤵︎ ---

	@objc func didMove() {
		statusBarController?.windowHandlerMouseDrag(event: nil)
	}

	@objc func willMove() {
		statusBarController?.setIsPanelBeingDragged(true)
	}
}

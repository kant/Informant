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

	/// This is the controller for the main panel
	public var panelController: InterfacePanelController<ContentView>?

	/// We use this status bar object to make managing the popover a lot easier.
	public var statusBarController: StatusBarController?

	/// We use this to access the menu bar status item. This toggles the panel open and closed. It's the main button.
	public var panelStatusItem: NSStatusItem?

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

	/// This contains all data needed for the interface.
	public var interfaceData: InterfaceData!

	/// This contains all the settings data needed for the application
	public var interfaceState: InterfaceState!

	// MARK: - Interface Helpers
	public var panelInterfaceHelper = InterfaceHelper()
	public var menubarInterfaceHelper = InterfaceHelper()

	// MARK: - Settings
	/// This is the window that displays all settings to the user
	public var settingsWindow: NSIFWindow!

	/// This sets up and controls the settings window's state
	public var settingsWindowController: SettingsWindowController!

	/// This sets up and controls the privacy accessibility authorization window
	public var privacyAccessibilityWindowController: IFWindowController<AuthAccessibilityView>!

	/// This is the auth window that's presented when the user doesn't have accessibility controls enabled
	public var privacyAccessibilityWindow: NSIFWindow!

	/// This sets up and controls the welcome window
	public var welcomeWindowController: IFWindowController<WelcomeView>!

	/// This is the welcome window that appears the first time the app is opened after an install
	public var welcomeWindow: NSIFWindow!

	// MARK: - Extra

	/// This keeps tracks of any items that need to be cached for later use
	public var cache: Cache!

	/// The view for the interface.
	public var contentView: ContentView!

	// MARK: - Async work blocks
	/// You can put background tasks on here to be completed. We use this because dispatch work items are cancellable
	var workQueue: [DispatchWorkItem] = []

	// ------------------ Main Program ⤵︎ ------------------

	func applicationDidFinishLaunching(_: Notification) {

		// MARK: - Settings Init

		registerUserDefaults()

		// MARK: - App initialization

		interfaceData = InterfaceData()

		interfaceState = InterfaceState()

		contentView = ContentView()

		cache = Cache()

		// MARK: - Privacy Init

		// Check accessibility authorization. Reminder: Prompt only shows up with no sandbox or a distribution profile
		interfaceState.privacyAccessibilityEnabled = AXIsProcessTrusted()

		// MARK: - Menu Init

		interfaceMenu = NSMenu()

		// Initializes the menu for the panel interface
		interfaceMenuController = InterfaceMenuController()

		// MARK: - Alert Init

		interfaceAlert = NSPanel(width: 210, height: 210, styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel])

		// Initialized the interface alert panel
		interfaceAlertController = InterfaceAlertController()

		// MARK: - Main Panel Init

		/// This is the main interface used by the application
		panel = NSPanel(width: 260, height: 500, styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel, .borderless])

		// Initiate setup
		panelController = InterfacePanelController(panel, contentView)

		// MARK: - Close Init

		interfaceClose = NSPanel(width: 0, height: 0, styleMask: [.fullSizeContentView, .nonactivatingPanel])

		// Sets up the close button (positions, sets up view, etc.)
		interfaceCloseController = InterfaceCloseController(interfaceClose)

		// MARK: - Settings Init

		settingsWindow = NSIFWindow([.fullSizeContentView, .closable, .titled, .miniaturizable, .unifiedTitleAndToolbar])

		// Setup the settings window
		if let settingsWindow = settingsWindow {
			settingsWindowController = SettingsWindowController(settingsWindow)
		}

		// MARK: - Privacy Accessibility Window Init

		privacyAccessibilityWindow = NSIFWindow([.fullSizeContentView, .closable, .titled, .unifiedTitleAndToolbar])

		// Setup the auth window
		if let authWindow = privacyAccessibilityWindow {
			privacyAccessibilityWindowController = IFWindowController(authWindow, AuthAccessibilityView())
		}

		// Open the auth window if no access is available
		if interfaceState.privacyAccessibilityEnabled == false {

			privacyAccessibilityWindowController.open()

			// Open up auth access dialog
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
				AXIsProcessTrustedWithOptions(options)
			}
		}

//		#warning("Remove from production: Remove")
//		privacyAccessibilityWindowController.open()

		// MARK: - Welcome Window Init

		// Check if this is the first app execution after install
		if UserDefaults.standard.bool(forKey: .keyShowWelcomeWindow), let isProcessTrusted = interfaceState.privacyAccessibilityEnabled {

			welcomeWindow = NSIFWindow([.fullSizeContentView, .closable, .titled, .unifiedTitleAndToolbar])

			// Setup the welcome window if accessibility is enabled
			if let welcomeWindow = welcomeWindow, isProcessTrusted {
				welcomeWindowController = IFWindowController(welcomeWindow, WelcomeView(interfaceState: interfaceState))
				welcomeWindowController.open()

				// Write that the first run after install has been acknowledged
				UserDefaults.standard.setValue(false, forKey: .keyShowWelcomeWindow)
			}
		}

		// MARK: - App Init

		// Initialize status bar
		statusBarController = StatusBarController()

		// MARK: - Additional Setup

		MenubarUtilityHelper.shouldMenubarUtilityAppearDisabled()

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

		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(appActivation),
			name: NSWorkspace.didActivateApplicationNotification,
			object: nil
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

	// --- Misc. selectors ---

	@objc func appActivation(notification: NSNotification) {

		let foundBundleID = String(describing: notification.userInfo?["NSWorkspaceApplicationKey"])

		// Grab Informant's app bundle id - com.tyirvine.Informant
		guard let appBundleID = NSRunningApplication.current.bundleIdentifier else {
			return
		}

		// Open settings
		if foundBundleID.contains(appBundleID) {

			// Check if settings is open
			if settingsWindow.isVisible == false {

				// If a window is visible then break execution of this fn.
				for window in NSApp.windows {
					if window.isKind(of: NSIFWindow.self), window.isVisible {
						print(window)
						return
					}
				}

				settingsWindowController.open()
			}
		}
	}

	// --- Selectors for sys. pref. changes ⤵︎ ---

	@objc func didAccessibilityChange() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

			// Check to see if accessibility controls are enabled in sys. prefs.
			if AXIsProcessTrusted() == false {
				self.interfaceState.privacyAccessibilityEnabled = false
				self.statusBarController?.updateInterfaces()
			}
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

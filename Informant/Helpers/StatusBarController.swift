//
//  StatusBarController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import AppKit

class StatusBarController {
	private var statusBar: NSStatusBar
	private var statusItem: NSStatusItem
	private var window: NSWindow!
	private var appDelegate: AppDelegate!

	private var monitorMouseDismiss: GlobalEventMonitor?

	init(appDelegate: AppDelegate) {
		self.appDelegate = appDelegate
		window = self.appDelegate.window
		statusBar = NSStatusBar.system

		// Creates a status bar item with a fixed length
		statusItem = statusBar.statusItem(withLength: 28)

		// Initializes menu bar button
		if let statusBarButton = statusItem.button {
			// Status bar icon image
			statusBarButton.image = NSImage(named: "MenubarIcon")

			// Status bar icon image size
			statusBarButton.image?.size = NSSize(width: 18, height: 18)

			// Decides whether or not the icon follows the macOS menubar colouring
			statusBarButton.image?.isTemplate = true

			// Updates constraint keeping the image in mind
			statusBarButton.updateConstraints()

			// Action
			statusBarButton.action = #selector(toggleWindow)
			statusBarButton.target = self
		}

		// Monitors mouse events
		monitorMouseDismiss = GlobalEventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mousedWindowHandler)
		monitorMouseDismiss?.start()
	}

	// Simply toggles display of window but does not close the window
	@objc func toggleWindow() {
		if window.isVisible {
			hideWindow()
		} else {
			showWindow()
		}
	}

	// Shows the window and starts monitoring for clicks
	func showWindow() {
		monitorMouseDismiss?.start()
		InterfaceHelper.DisplayUpdatedInterface(appDelegate: appDelegate)
		window.setIsVisible(true)
		NSRunningApplication.current.activate(options: [.activateIgnoringOtherApps])
	}

	// Hides the window and stops monitoring for clicks
	func hideWindow() {
		monitorMouseDismiss?.stop()
		NSApplication.shared.deactivate()
		window.setIsVisible(false)
	}

	// Hides interface if no finder items are selected. Otherwise update the interface
	func mousedWindowHandler(event: NSEvent?) {

		// Get finder items
		let selectedItems: [String] = AppleScripts.findSelectedFiles()

		// Items are selected so update the interface
		if selectedItems[0] != "", window.isVisible {
			showWindow()
		}

		// No items are selected, therefore hide the interface
		else {
			hideWindow()
		}
	}
}

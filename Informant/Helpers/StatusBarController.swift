//
//  StatusBarController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import AppKit

// TODO: Clean this file up and possibly split it into some different classes
class StatusBarController {
	private var statusBar: NSStatusBar
	private var statusItem: NSStatusItem
	private var window: NSWindow!
	private var appDelegate: AppDelegate!

	// Monitors
	private var monitorMouseDismiss: GlobalEventMonitor?
	private var monitorKeyPress: GlobalEventMonitor?

	init(appDelegate: AppDelegate) {
		// Assigns app delegate
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
		monitorMouseDismiss = GlobalEventMonitor(mask: [.leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp], handler: mousedWindowHandler)
		monitorMouseDismiss?.start()

		// Monitors key events
		monitorKeyPress = GlobalEventMonitor(mask: [.keyDown, .keyUp], handler: keyedWindowHandler)
		monitorKeyPress?.start()
	}

	// MARK: - Window Functions

	// Simply toggles display of window but does not close the window
	@objc func toggleWindow() {
		if window.isVisible {
			hideWindow()
		}
		else {
			openWindow()
		}
	}

	// Shows the window and starts monitoring for clicks
	func openWindow() {
		monitorMouseDismiss?.start()
		monitorKeyPress?.start()
		InterfaceHelper.DisplayUpdatedInterface(appDelegate: appDelegate)
		window.setIsVisible(true)
	}

	// Hides the window and stops monitoring for clicks
	func hideWindow() {
		monitorMouseDismiss?.stop()
		monitorKeyPress?.stop()
		window.setIsVisible(false)
	}

	// Simply updates the interface. Just here to avoid code duplication
	func updateWindow() {
		InterfaceHelper.DisplayUpdatedInterface(appDelegate: appDelegate)
	}

	// MARK: - Monitor Functions

	// Hides interface if no finder items are selected. Otherwise update the interface - based on left and right clicks
	func mousedWindowHandler(event: NSEvent?) {
		// Get finder items
		let selectedItems: [String] = AppleScripts.findSelectedFiles()

		// Items are selected so update the interface
		if selectedItems[0] != "", window.isVisible {
			updateWindow()
		}

		// No items are selected, therefore hide the interface
		else {
			hideWindow()
		}
	}

	/// Used by the keyedWindowHandler to decide how many updates to the interface to do
	var keyCounter = 0

	/// Used by the key down monitor, this updates the interface if it's an arrow press and closes it with any other press
	func keyedWindowHandler(event: NSEvent?) {

		if event!.isARepeat {

			// If it's a repeating key update the interface every other key instead
			keyCounter += 1

			// A good blend between performance and power consumption
			if keyCounter >= 10 {
				updateWindow()
				keyCounter = 0
				return
			}
			else {
				return
			}
		}

		let key = event?.keyCode

		switch key {
		// If arrow press then update the interface
		case 123, 124, 125, 126:
			updateWindow()
			break

		// If it's an escape key hide the window, and otherwise do nothing
		case 53:
			hideWindow()
			break

		default:
			break
		}
	}
}

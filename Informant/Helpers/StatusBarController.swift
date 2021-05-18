//
//  StatusBarController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// TODO: Clean this file up and possibly split it into some different classes
class StatusBarController {
	private var statusBar: NSStatusBar
	private var statusItem: NSStatusItem
	private var window: NSWindow!
	private var appDelegate: AppDelegate!

	// Monitors
	private var monitorMouseDismiss: GlobalEventMonitor?
	private var monitorKeyPress: GlobalEventMonitor?

	// This stores the window's position for each screen
	private var windowScreenPositions: [Int: CGPoint] = [:]

	init(appDelegate: AppDelegate) {

		self.appDelegate = appDelegate
		window = self.appDelegate.window
		statusBar = NSStatusBar.system

		// Creates a status bar item with a fixed length
		statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

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
			statusBarButton.action = #selector(toggleWindowToStatusItem)
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

	// Toggle the window and perform some functionallity specific to the status bar
	@objc func toggleWindowToStatusItem() {
		if window.isVisible {
			baseHideWindow()
		}
		else {
			statusItemOpenWindow()
		}
	}

	// Simply toggles display of window but does not close the window
	@objc func toggleWindow() {
		if window.isVisible {
			hideWindow()
		}
		else {
			openWindow()
		}
	}

	// Behaviour for all window hides and opens
	func baseHideWindow() {
		monitorMouseDismiss?.stop()
		monitorKeyPress?.stop()
		window.setIsVisible(false)
	}

	func baseOpenWindow() {
		monitorMouseDismiss?.start()
		monitorKeyPress?.start()
	}

	// A specific opening sequence for the status item
	func statusItemOpenWindow() {
		baseOpenWindow()

		// Find status item position by accessing it's button's window!
		let statusItemFrame = statusItem.button!.window!.frame

		// Shave off half the width of the interface off the x-coordinate
		let xPositionAdjustedByWindow = statusItemFrame.midX - (window.frame.width / 2.0)

		// Move the window down a hair so it's not riding directly on the menu bar
		let yPosition = statusItemFrame.origin.y - 8.0

		// Create and set the window to the new coordinates
		let newAdjustedOrigin = CGPoint(x: xPositionAdjustedByWindow, y: yPosition)
		window.setFrameTopLeftPoint(NSPointFromCGPoint(newAdjustedOrigin))

		// Update the interface
		updateWindow()

		window.setIsVisible(true)
	}

	// Shows the window and starts monitoring for clicks
	func openWindow() {
		baseOpenWindow()

		// Grab the window's location
		let windowLocation = NSPointFromCGPoint(window.frame.origin)

		// Check if the window is in the main screen
		// If it's not in the correct screen then move it to that screen's position
		if !NSMouseInRect(windowLocation, NSScreen.main!.frame, false) {

			// Find window's position by using the screen's index
			guard let screenOrigin = windowScreenPositions[NSScreen.main!.hash] else {
				// If it doesn't have a screen position then just open it in the center of the screen
				window.center()

				// Save window's new origin
				windowScreenPositions[window.screen!.hashValue] = window.frame.origin

				print("No origin point found")
				return
			}

			// Assign window to the discorvered origin
			window.setFrameOrigin(screenOrigin)
		}

		InterfaceHelper.DisplayUpdatedInterface(appDelegate: appDelegate)
		window.setIsVisible(true)
	}

	// Hides the window and stops monitoring for clicks
	func hideWindow() {
		baseHideWindow()
		// Store window's position using the screen's hash where the window is opened
		windowScreenPositions[window.screen!.hashValue] = window.frame.origin
	}

	// Simply updates the interface. Just here to avoid code duplication
	func updateWindow() {
		InterfaceHelper.DisplayUpdatedInterface(appDelegate: appDelegate)
	}

	// MARK: - Monitor Functions

	// Hides interface if no finder items are selected. Otherwise update the interface - based on left and right clicks
	func mousedWindowHandler(event: NSEvent?) {

		// If we're interacting with the application window then don't do anything
		if event?.window == appDelegate.window {
			return
		}

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

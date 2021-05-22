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
	private var monitorEscPress: GlobalEventMonitor?

	/// This stores the window's position for each screen
	private var windowScreenPositions: [Int: CGPoint] = [:]

	/// This stores the first selected file in the user's selection.
	///
	/// We use this to ensure that, when clicking on another menubar app,
	/// Informant doesn't think that we still want details about the selected item.
	///
	/// Allows user to click on another menubar app without the Informant interface getting in the way.
	private var currentItemSelection: String = ""

	// ------------ Initialization ⤵︎ -------------

	init() {
		// Initialization of all objects
		appDelegate = AppDelegate.current()
		window = appDelegate.window
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

			// This is the button's action it executes upon activation
			statusBarButton.action = #selector(toggleInterfaceByClick)
			statusBarButton.target = self
		}

		// Monitors mouse events
		monitorMouseDismiss = GlobalEventMonitor(mask: [.leftMouseDown, .rightMouseDown, .leftMouseUp, .rightMouseUp], handler: windowHandlerMouse)

		// Monitors key events
		monitorKeyPress = GlobalEventMonitor(mask: [.keyDown, .keyUp], handler: windowHandlerArrowKeys)

		// Monitors esc key events
		monitorEscPress = GlobalEventMonitor(mask: .keyDown, handler: windowHandlerEscKeys)
	}

	// MARK: - Extraneous Methods

	/// Small function used to toggle the interface by click
	@objc func toggleInterfaceByClick() {
		InterfaceHelper.ToggleInterfaceByClick()
	}

	/// Find status item button location
	func statusItemButtonPosition() -> NSPoint {
		// Find status item position by accessing it's button's window!
		let statusItemFrame = statusItem.button!.window!.frame

		// Shave off half the width of the interface off the x-coordinate
		let xPositionAdjustedByWindow = statusItemFrame.midX - (window.frame.width / 2.0)

		// Move the window down a hair so it's not riding directly on the menu bar
		let yPosition = statusItemFrame.origin.y - 6.0

		// Create and set the window to the new coordinates
		return NSPointFromCGPoint(CGPoint(x: xPositionAdjustedByWindow, y: yPosition))
	}

	// MARK: - Window Toggle Functionality

	/// Used to define how the interface is being toggled
	enum ToggleMethod {
		case Key
		case Click
	}

	// Simply toggles display of window based on toggle method. Only changes visibility
	func toggleWindow(toggleMethod: ToggleMethod) {

		// Close window if it's visible and end execution
		if window.isVisible {
			hideWindow()
			return
		}

		// Perform remaining logic based on toggle method
		switch toggleMethod {

		case ToggleMethod.Key:
			// Find window's position by using the screen's index
			if let screenOrigin = windowScreenPositions[NSScreen.main!.hash] {
				window.setFrameOrigin(screenOrigin)
			}

			// If it doesn't have a screen position then just open it by the status item button and
			// save new window origin to dictionary
			else {
				window.setFrameTopLeftPoint(statusItemButtonPosition())
				windowScreenPositions[window.screen!.hashValue] = window.frame.origin
			}
			break

		case ToggleMethod.Click:
			window.setFrameTopLeftPoint(statusItemButtonPosition())
			break
		}

		showWindow()
	}

	// MARK: - Window Functions

	/// Hides the window, stops monitoring for clicks and stores window's position using the screen's hash where the window is opened
	/// and restores focus to previously active application.
	func hideWindow() {
		windowScreenPositions[window.screen!.hashValue] = window.frame.origin
		window.setIsVisible(false)
		window.resignKey()
		monitorsStop()
	}

	/// Shows the window and ensures that application takes focus from any other active application.
	/// [For more info see this documentation](https://www.notion.so/brewsoftwarehouse/Major-display-issue-06dede77d6cd499e86d1e92b5fc188b1)
	func showWindow() {
		updateWindow()
		window.becomeKey()
		window.setIsVisible(true)
		monitorsStart()
	}

	/// Simply updates the interface. Just here to avoid code duplication. Also update current item selection
	func updateWindow() {
		currentItemSelection = AppleScripts.findSelectedFiles()[0]
		InterfaceHelper.DisplayUpdatedInterface()
	}

	// MARK: - Monitor Control Functions

	func monitorsStart() {
		monitorMouseDismiss?.start()
		monitorKeyPress?.start()
		monitorEscPress?.start()
	}

	func monitorsStop() {
		monitorMouseDismiss?.stop()
		monitorKeyPress?.stop()
		monitorEscPress?.stop()
	}

	// MARK: - Monitor Handler Functions

	// Hides interface if no finder items are selected. Otherwise update the interface - based on left and right clicks
	func windowHandlerMouse(event: NSEvent?) {

		// If we're interacting with the application window then don't do anything
		if event?.window == appDelegate.window {
			return
		}

		// Get finder items
		let selectedItems: [String] = AppleScripts.findSelectedFiles()

		// Otherwise, new items are selected so update the interface and store current item selected for next click
		if selectedItems[0] != "" && window.isVisible {
			updateWindow()
		}

		// No items are selected, therefore hide the interface
		else {
			hideWindow()
		}
	}

	/// Used by the keyedWindowHandler to decide how many updates to the interface to do
	var keyCounter = 0

	/// Used by the key down & up monitor, this updates the interface if it's an arrow press and closes it with any other press
	func windowHandlerArrowKeys(event: NSEvent?) {

		/// If it's a repeating key, update the interface every other key instead
		/// Once the user lifts the key this function is called again - that key lift doesn't count as a repeating key.
		/// So that means that this block ⤵︎ is skipped when the user lifts their held keypress meaning that
		/// the interface will get updated immediately with the selected file.

		/// Finder uses simillar functionallity with it's quicklook
		if event!.isARepeat {

			// Adds to count and will only update when the threshold below is reached
			keyCounter += 1

			// Checks every 10 items. A good blend between performance and power consumption
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

		default:
			break
		}
	}

	/// Used by a key down monitor to look for escape key presses
	func windowHandlerEscKeys(event: NSEvent?) {

		// Escape handler if it's a repeat
		if event!.isARepeat {
			return
		}

		// Grab key code
		let key = event!.keyCode

		// Check for esc key press
		if key == 53 {
			hideWindow()
		}
	}
}

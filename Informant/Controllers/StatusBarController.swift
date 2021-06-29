//
//  StatusBarController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

class StatusBarController {

	private var statusBar: NSStatusBar
	private var statusItem: NSStatusItem
	private var window: NSPanel!
	private var appDelegate: AppDelegate!

	private var settings: InterfaceState!

	// Monitors
	private var monitorMouseDismiss: GlobalEventMonitor?
	private var monitorKeyPress: GlobalEventMonitor?
	private var monitorMouseDrag: GlobalEventMonitor?

	/// Stores the window's position for each screen
	private var windowScreenPositions: [Int: CGPoint] = [:]

	/// Stores panel snap drag zone
	private var panelSnapDragZone: NSRect?

	/// Lets us know if the panel has been dragged
	private var isPanelBeingDragged: Bool?

	/// States for hiding the interface
	enum InterfaceHiding {
		case Open
		case ReadyToHide
		case Hidden
	}

	/// State object that tells us if the interface is ready to be hidden or not
	var interfaceHidingState: InterfaceHiding = .Open

	// ------------ Initialization ⤵︎ -------------

	init() {

		// Initialization of all objects
		appDelegate = AppDelegate.current()
		window = appDelegate.window
		statusBar = NSStatusBar.system

		settings = appDelegate.interfaceState

		// Creates a status bar item with a fixed length
		statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

		// Initializes menu bar button
		if let statusBarButton = statusItem.button {
			// Status bar icon image
			statusBarButton.image = NSImage(named: ContentManager.Icons.menuBar)

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
		monitorMouseDismiss = GlobalEventMonitor(mask: [.leftMouseDown, .rightMouseDown, .leftMouseUp, .rightMouseUp], handler: windowHandlerMouseDismiss)

		// Monitors key events
		monitorKeyPress = GlobalEventMonitor(mask: [.keyDown, .keyUp], handler: windowHandlerArrowKeys)

		// Monitors mouse drags on the panel
		monitorMouseDrag = GlobalEventMonitor(mask: [.leftMouseUp, .rightMouseUp], handler: windowHandlerMouseDrag)
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

		// Move the panel down a hair so it's not riding directly on the menu bar
		let yPosition = statusItemFrame.origin.y - 6.0

		// Create and set the panel to the new coordinates
		return NSPointFromCGPoint(CGPoint(x: xPositionAdjustedByWindow, y: yPosition))
	}

	/// Helper function to let us know what type of event the provided one is
	func eventTypeCheck(_ event: NSEvent?, types: [NSEvent.EventType]) -> Bool {
		for type in types {
			if event?.type == type {
				return true
			}
		}

		// All checks down with no positives found
		return false
	}

	/// Helper designed to set the drag state of the object
	func setIsPanelBeingDragged(_ value: Bool) {
		isPanelBeingDragged = value
	}

	// MARK: - Window Toggle Functionality

	/// Used to define how the interface is being toggled
	enum ToggleMethod {
		case Key
		case Click
	}

	// Simply toggles display of panel based on toggle method. Only changes visibility
	func toggleWindow(toggleMethod: ToggleMethod) {

		// Check to see if the active space changed
		// Close panel if it's visible and end execution
		if window.isVisible {
			if window.isOnActiveSpace {
				hideWindow()
			}
			else {
				window.orderFrontRegardless()
			}
			return
		}

		// Perform remaining logic based on toggle method
		switch toggleMethod {

		case ToggleMethod.Key:
			// Find panel's position by using the screen's index
			if let screenOrigin = windowScreenPositions[NSScreen.main!.hash] {
				window.setFrameOrigin(screenOrigin)
			}

			// If it doesn't have a screen position then just open it by the status item button and
			// save new panel origin to dictionary
			else {
				window.setFrameTopLeftPoint(statusItemButtonPosition())
				windowScreenPositions[window.screen.hashValue] = window.frame.origin
			}
			break

		case ToggleMethod.Click:
			window.setFrameTopLeftPoint(statusItemButtonPosition())
			break
		}

		showWindow()
	}

	// MARK: - Window Functions

	/// Hides the panel, stops monitoring for clicks and stores panel's position using the screen's hash where the panel is opened
	/// and restores focus to previously active application.
	func hideWindow() {

		/// This runs all logic involved to hide the panel, including resetting the alpha value back to 1
		func hideWindowLogic() {
			windowScreenPositions[window.screen.hashValue] = window.frame.origin
			window.setIsVisible(false)
			monitorsStop()
			interfaceHidingState = .Hidden
			window.alphaValue = 1
			setIsPanelBeingDragged(false)
		}

		// This sets the window's alpha value prior to animating it
		window.alphaValue = 1

		// This is the window's hiding animation
		NSAnimationContext.runAnimationGroup { (context) -> Void in
			context.duration = TimeInterval(0.25)
			window.animator().alphaValue = 0
		} completionHandler: {
			hideWindowLogic()
		}
	}

	/// Shows the panel and updates the interface.
	/// [For more info see this documentation](https://www.notion.so/brewsoftwarehouse/Major-display-issue-06dede77d6cd499e86d1e92b5fc188b1)
	func showWindow() {
		updateWindow()
		window.setIsVisible(true)
		monitorsStart()

		// Makes sure close button is tappable
		if let child = window.childWindows {
			child[0].orderFront(nil)
		}
	}

	/// Simply updates the interface. Just here to avoid code duplication. Also updates current item selection.
	/// As well, makes sure that hiding state is set properly.
	func updateWindow() {

		InterfaceHelper.DisplayUpdatedInterface()

		// Check for null interface data and set hiding state accordingly.
		// When interface data is present -> .Open
		if appDelegate.interfaceData != nil {
			appDelegate.statusBarController?.interfaceHidingState = .Open
		}

		// When no interface data is present -> .ReadyToHide
		else {
			appDelegate.statusBarController?.interfaceHidingState = .ReadyToHide
		}
	}

	// MARK: - Monitor Control Functions

	func monitorsStart() {
		monitorMouseDismiss?.start()
		monitorKeyPress?.start()
		monitorMouseDrag?.start()
	}

	func monitorsStop() {
		monitorMouseDismiss?.stop()
		monitorKeyPress?.stop()
		monitorMouseDrag?.stop()
	}

	// MARK: - Monitor Handler Functions

	// MARK: Mouse Dismiss
	// Hides interface if no finder items are selected. Otherwise update the interface - based on left and right clicks
	func windowHandlerMouseDismiss(event: NSEvent?) {

		// If we're interacting with the application panel then don't do anything
		if event?.window == appDelegate.window {
			return
		}

		// Get finder items
		let selectedItems: [String]? = AppleScriptsHelper.findSelectedFiles()?.paths

		// Otherwise, new items are selected so update the interface and store current item selected for next click
		if selectedItems != nil && window.isVisible {
			updateWindow()
		}

		// No items are selected, therefore prep to hide the interface
		else if eventTypeCheck(event, types: [.leftMouseDown, .rightMouseDown]) {
			switch interfaceHidingState {
			case .Open:
				interfaceHidingState = .ReadyToHide
				updateWindow()
				break

			case .ReadyToHide:
				hideWindow()
				break

			case .Hidden:
				break
			}
		}
	}

	// MARK: Key Detection
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

		// If esc key press is detected on down press then hide the interface
		case 53:
			if event?.type == NSEvent.EventType.keyDown {
				hideWindow()
			}
			break

		// If ⌘ + a is pressed to signify a select all then update the interface
		case 0:
			if event?.modifierFlags.contains(.command) == true {
				updateWindow()
			}
			break

		default:
			break
		}
	}

	// MARK: Mouse Drag
	/// Detects drags on the panel when open. Snaps the panel to the starting panel position if near the StatusItemButton.
	/// This only gets triggered after a drag, so it's okay to build the snap-zone in here. Do not spam this method!
	func windowHandlerMouseDrag(event: NSEvent?) {

		// Make sure the mouse is dragging on the panel - if not then back out
		if isPanelBeingDragged != true, event?.window != appDelegate.window {
			return
		}

		// Make sure that the panel is dragging
		else if isPanelBeingDragged != true {
			return
		}

		// ------------ Establish Panel Snap Zone -------------

		// Grab StatusItemButton position
		guard let statusItemFrame = statusItem.button?.window?.frame else {
			return
		}

		// Grabs the bottom mid point of the status item button in the menu bar
		let statusItemBottomMidPoint = NSPoint(x: statusItemFrame.midX, y: statusItemFrame.minY)

		// Offset it ⤴︎
		let offset: CGFloat = 150.0
		let panelSnapDragZoneOrigin = CGPoint(x: statusItemBottomMidPoint.x - (offset / 2), y: statusItemBottomMidPoint.y - (offset / 2))
		let panelSnapDragZoneSize = CGSize(width: offset, height: offset)

		// Create a detection box
		panelSnapDragZone = NSRect(origin: panelSnapDragZoneOrigin, size: panelSnapDragZoneSize)

		// Make sure panel snap drag zone is established
		guard let panelSnapZone = panelSnapDragZone else {
			return
		}

		// ------------- Panel Snap Zone is established ---------------

		// Get the center point of the panel
		let panelTopCenter = NSPoint(x: window.frame.midX, y: window.frame.maxY)

		// See if the panel is in the starting panel position zone
		let isPanelInSnapZone = NSMouseInRect(panelTopCenter, panelSnapZone, false)

		// Make the panel blurred if it's being dragged and in the snap zone
		if isPanelInSnapZone && window.alphaValue == 1.0 {
			settings.setIsPanelInSnapZone(true)
		}

		// Reset the panel blur because we're no longer in the snap zone
		else if isPanelInSnapZone == false {
			settings.setIsPanelInSnapZone(false)
		}

		// On release of the drag, if in the position zone, snap the panel's position to the starting position
		if isPanelInSnapZone && eventTypeCheck(event, types: [.leftMouseUp, .rightMouseUp]) {

			// Resets panel blurring
			settings.setIsPanelInSnapZone(false)

			// Animates window to 0 opacity and then calls to the next animation phase
			NSAnimationContext.runAnimationGroup { (context) -> Void in
				context.duration = TimeInterval(0.15)
				window.animator().alphaValue = 0
			} completionHandler: {
				panelMoveAndSetAlphaAnimation()
			}
		}

		// Otherwise backout
		else {
			return
		}

		/// Snaps window to starting position and then makes it visible
		func panelMoveAndSetAlphaAnimation() {
			window.animator().setFrameTopLeftPoint(statusItemButtonPosition())
			window.animator().alphaValue = 1
			setIsPanelBeingDragged(false)
		}
	}
}

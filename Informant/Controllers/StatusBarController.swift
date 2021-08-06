//
//  StatusBarController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

class StatusBarController {

	private var statusBar: NSStatusBar

	private var panelStatusItem: NSStatusItem?

	private var panel: NSPanel!
	private var appDelegate: AppDelegate!

	private var settings: InterfaceState

	// Monitors
	public var monitorMouseDismiss: GlobalEventMonitor?
	public var monitorKeyPress: GlobalEventMonitor?
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
		panel = appDelegate.panel
		statusBar = NSStatusBar.system

		settings = appDelegate.interfaceState

		// Creates a status bar item with a fixed length
		appDelegate.panelStatusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

		// Assign status items
		panelStatusItem = appDelegate.panelStatusItem

		// Initializes menu bar button
		if let panelBarButton = panelStatusItem?.button {

			// Status bar icon image
			panelBarButton.image = NSImage(named: ContentManager.Icons.menuBar)

			// Status bar icon image size
			panelBarButton.image?.size = NSSize(width: 17.5, height: 17.5)

			// Decides whether or not the icon follows the macOS menubar colouring
			panelBarButton.image?.isTemplate = true

			panelBarButton.imagePosition = .imageTrailing
			panelBarButton.imageHugsTitle = false

			// Updates constraint keeping the image in mind
			panelBarButton.updateConstraints()

			// This is the button's action it executes upon activation
			panelBarButton.action = #selector(statusItemClickDirector)
			panelBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
			panelBarButton.target = self
		}

		// Monitors mouse events
		monitorMouseDismiss = GlobalEventMonitor(mask: [.leftMouseDown, .rightMouseDown, .leftMouseUp, .rightMouseUp], handler: windowHandlerMouseDismiss)

		// Monitors key events
		monitorKeyPress = GlobalEventMonitor(mask: [.keyDown, .keyUp], handler: windowHandlerArrowKeys)

		// Monitors mouse drags on the panel
		monitorMouseDrag = GlobalEventMonitor(mask: [.leftMouseUp, .rightMouseUp], handler: windowHandlerMouseDrag)

		// These get stopped when the application is torn down
		monitorMouseDismiss?.start()
		monitorKeyPress?.start()
	}

	// MARK: - Monitor Control Functions

	func monitorsStart() {
		monitorMouseDrag?.start()
	}

	func monitorsStop() {
		monitorMouseDrag?.stop()
	}

	// MARK: - Extraneous Methods

	/// Routes traffic to the correct left/right action.
	@objc func statusItemClickDirector() {

		let event = NSApp.currentEvent

		if event?.type == NSEvent.EventType.leftMouseUp {

			// Makes sure to steal focus from any other menu bar apps
			panelStatusItem?.menu = NSMenu()
			panelStatusItem?.button?.performClick(nil)
			panelStatusItem?.menu = nil

			toggleInterfaceByClick()
		}
		else {
			appDelegate.interfaceMenuController?.updateMenu()
			panelStatusItem?.menu = appDelegate.interfaceMenu
			panelStatusItem?.button?.performClick(nil)
			panelStatusItem?.menu = nil
		}
	}

	/// Small function used to toggle the interface by click
	@objc func toggleInterfaceByClick() {
		InterfaceHelper.ToggleInterfaceByClick()
	}

	/// Find status item button location
	func statusItemButtonPosition() -> NSPoint {

		// Find status item position by accessing it's button's window!
		guard let statusItemFrame = panelStatusItem?.button?.window?.frame else {
			return NSPoint()
		}

		// Get the image
		guard let image = panelStatusItem?.button?.image else {
			return NSPoint()
		}

		// Get the middle of the image
		let imageMidPosition = statusItemFrame.maxX - image.alignmentRect.width

		// Shave off half the width of the interface off the x-coordinate
		let xPositionAdjustedByWindow = imageMidPosition - (panel.frame.width / 2.0)

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

		if panel.isVisible {

			// Close panel if it's visible in the current window and end execution
			if panel.isOnActiveSpace {
				hideInterfaces()
			}

			// Otherwise, show the window on the current active space
			else {
				showPanel()
			}
			return
		}

		// Perform remaining logic based on toggle method
		switch toggleMethod {

		case ToggleMethod.Key:
			// Find panel's position by using the screen's index
			if let screenOrigin = windowScreenPositions[NSScreen.main!.hash] {
				panel.setFrameOrigin(screenOrigin)
			}

			// If it doesn't have a screen position then just open it by the status item button and
			// save new panel origin to dictionary
			else {
				panel.setFrameTopLeftPoint(statusItemButtonPosition())
				windowScreenPositions[panel.screen.hashValue] = panel.frame.origin
			}
			break

		case ToggleMethod.Click:
			panel.setFrameTopLeftPoint(statusItemButtonPosition())
			break
		}

		showPanel()
	}

	// MARK: - Window Functions

	/// Shows the panel and updates the interface.
	/// [For more info see this documentation](https://www.notion.so/brewsoftwarehouse/Major-display-issue-06dede77d6cd499e86d1e92b5fc188b1)
	func showPanel() {

		// Get the authorization status here
		settings.privacyAccessibilityEnabled = AXIsProcessTrusted()

		// Reset panel snap zone always
		settings.setIsPanelInSnapZone(false)
		setIsPanelBeingDragged(false)

		// Reset panel's close button position
		appDelegate.interfaceCloseController?.setPosition()

		// Show panel
		updatePanel(force: true)
		panel.setIsVisible(true)
		monitorsStart()

		// Makes sure close button is tappable by ordering it to the front
		if let child = panel.childWindows?.first {
			child.orderFront(nil)
		}
	}

	/// Hides the panel, stops monitoring for clicks and stores panel's position using the screen's hash where the panel is opened
	/// and restores focus to previously active application.
	func hideInterfaces() {

		if panel.isVisible {
			hidePanel()
		}
		else {
			hideMenubarUtility()
		}
	}

	/// Simply hides the panel
	func hidePanel() {

		/// This runs all logic involved to hide the panel, including resetting the alpha value back to 1
		func hideWindowLogic() {
			windowScreenPositions[panel.screen.hashValue] = panel.frame.origin
			panel.setIsVisible(false)
			panel.alphaValue = 1
			monitorsStop()
			setIsPanelBeingDragged(false)

			// Reset panel snap zone always
			settings.setIsPanelInSnapZone(false)

			// Delete current selection in memory
			appDelegate.panelInterfaceHelper.ResetState()
		}

		// Makes sure to set the state of the panel as hidden
		interfaceHidingState = .Hidden

		// Hide close button
		settings.isMouseHoveringClose = false

		// This sets the window's alpha value prior to animating it
		panel.alphaValue = 1

		// This is the window's hiding animation
		NSAnimationContext.runAnimationGroup { context -> Void in
			context.duration = TimeInterval(0.25)
			panel.animator().alphaValue = 0
		} completionHandler: {
			hideWindowLogic()
		}
	}

	/// Simply updates the interface. Just here to avoid code duplication. Also updates current item selection.
	/// As well, makes sure that hiding state is set properly.
	func updateInterfaces() {

		// Make sure the app is not paused
		if settings.settingsPauseApp == true {
			return
		}

		// Wipe the menubar utility
		updateMenubarUtility()

		// Make sure the interface is visible
		if panel.isVisible {
			updatePanel()
		}
	}

	/// Updates the panel interface itself. This can be used to force updates
	func updatePanel(force: Bool = false) {

		// Make sure the app is not paused
		if settings.settingsPauseApp == false {

			// Open up the interface
			InterfaceHelper.DisplayUpdatedInterface(force: force)
		}

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

	/// Simply updates the menubar utility interface and presents it with the correct value
	func updateMenubarUtility() {
		checkMenubarUtilitySettings()
	}

	/// Simply removes the menubar utility interface
	func hideMenubarUtility() {
		MenubarUtilityHelper.wipeMenubarInterface()
	}

	/// Checks if the menubar utility is visible based on user settings
	func checkMenubarUtilitySettings() {
		if settings.settingsMenubarUtilityBool, settings.privacyAccessibilityEnabled == true {
			MenubarUtilityHelper.update()
		}
		else {
			MenubarUtilityHelper.wipeMenubarInterface(resetState: false)
		}
	}

	// MARK: - Monitor Handler Functions

	// MARK: Mouse Dismiss
	// Hides interface if no finder items are selected. Otherwise update the interface - based on left and right clicks
	func windowHandlerMouseDismiss(event: NSEvent?) {

		// If we're interacting with the application panel then don't do anything
		if event?.window == appDelegate.panel {
			return
		}

		// Get finder items
		let selectedItems: [String]? = AppleScriptsHelper.findSelectedFiles()?.paths

		// Otherwise, new items are selected so update the interface and store current item selected for next click
		if selectedItems != nil, eventTypeCheck(event, types: [.leftMouseUp, .rightMouseUp]) {
			updateInterfaces()
		}

		// No items are selected, therefore prep to hide the interface
		else if eventTypeCheck(event, types: [.leftMouseUp, .rightMouseUp]) {
			switch interfaceHidingState {
			case .Open:
				interfaceHidingState = .ReadyToHide
				InterfaceHelper.ResetAllStates()
				updateInterfaces()
				break

			case .ReadyToHide:
				hideInterfaces()
				break

			case .Hidden:
				hideInterfaces()
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
				updateInterfaces()
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
			updateInterfaces()
			break

		// If esc key press is detected on down press then hide the interface
		case 53:
			if event?.type == NSEvent.EventType.keyDown {
				hideInterfaces()
			}
			break

		// If ⌘ + a is pressed to signify a select all then update the interface
		case 0:
			if event?.modifierFlags.contains(.command) == true {
				updateInterfaces()
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
		if isPanelBeingDragged != true, event?.window != appDelegate.panel {
			return
		}

		// Make sure that the panel is dragging
		else if isPanelBeingDragged != true {
			return
		}

		// ------------ Establish Panel Snap Zone -------------

		// Grab StatusItemButton position
		guard let statusItemFrame = panelStatusItem?.button?.window?.frame else {
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
		let panelTopCenter = NSPoint(x: panel.frame.midX, y: panel.frame.maxY)

		// See if the panel is in the starting panel position zone
		let isPanelInSnapZone = NSMouseInRect(panelTopCenter, panelSnapZone, false)

		// Make the panel blurred if it's being dragged and in the snap zone
		if isPanelInSnapZone && panel.alphaValue == 1.0 {
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
			NSAnimationContext.runAnimationGroup { context -> Void in
				context.duration = TimeInterval(0.15)
				panel.animator().alphaValue = 0
				settings.isMouseHoveringClose = false
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
			panel.animator().setFrameTopLeftPoint(statusItemButtonPosition())
			panel.animator().alphaValue = 1
			setIsPanelBeingDragged(false)
		}
	}
}

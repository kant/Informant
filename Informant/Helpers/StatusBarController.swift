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
	private var popover: NSPopover
	private var eventMonitor: EventMonitor?

	init(_ popover: NSPopover) {
		self.popover = popover
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

			// Action
			statusBarButton.action = #selector(togglePopover(sender:))
			statusBarButton.target = self
		}

		// Monitors mouse events
		eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
	}

	// Toggles popover
	@objc func togglePopover(sender: AnyObject) {
		if popover.isShown {
			hidePopover(sender)
		}
		else {
			showPopover(sender)
		}
	}

	// Shows popover
	func showPopover(_ sender: AnyObject) {
		if let statusBarButton = statusItem.button {
			// Create sub view
			let positioningView = NSView(frame: statusBarButton.bounds)
			positioningView.identifier = NSUserInterfaceItemIdentifier(rawValue: "positioningView")
			statusBarButton.addSubview(positioningView)

			// Show and move popover
			popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
			statusBarButton.bounds = statusBarButton.bounds.offsetBy(dx: 0, dy: statusBarButton.bounds.height)

			// Move popover up a bit
			if let popoverWindow = popover.contentViewController?.view.window {
				popoverWindow.setFrame(popoverWindow.frame.offsetBy(dx: 0, dy: 8), display: false)
			}

			// Begin monitoring for user close action
			eventMonitor?.start()
		}
	}

	// Hides popover
	func hidePopover(_ sender: AnyObject) {
		popover.performClose(sender)

		// Remove popover view
		let positioningView = sender.subviews?.first {
			$0.identifier == NSUserInterfaceItemIdentifier(rawValue: "positioningView")
		}
		positioningView?.removeFromSuperview()

		// Stop monitoring for user close action
		eventMonitor?.stop()
	}

	// Hides popover on mouse action
	func mouseEventHandler(_ event: NSEvent?) {
		if popover.isShown {
			hidePopover(event!)
		}
	}
}

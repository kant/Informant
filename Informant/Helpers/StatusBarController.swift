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
			popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
			eventMonitor?.start()
		}
	}

	// Hides popover
	func hidePopover(_ sender: AnyObject) {
		popover.performClose(sender)
		eventMonitor?.stop()
	}

	// Hides popover on mouse action
	func mouseEventHandler(_ event: NSEvent?) {
		if popover.isShown {
			hidePopover(event!)
		}
	}
}

//
//  InterfaceCloseController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-28.
//

import Foundation
import SwiftUI

class InterfaceCloseController {

	var appDelegate = AppDelegate.current()
	var close: NSPanel

	// ------------- Initialization ⤵︎ -------------

	init(_ panelRef: NSPanel) {

		// Assign ref. for panel
		close = panelRef

		// Sets the position to the corner of the view
		setPosition()

		// Titlebar setup
		close.titlebarAppearsTransparent = true
		close.titleVisibility = .hidden

		// Aesthetics
		close.alphaValue = 1.0
		close.hasShadow = true

		// Animation
		close.animationBehavior = .none

		// Assign content to panel
		close.contentViewController = NSHostingController(rootView: PanelCloseButton())
		close.isOpaque = true
		close.backgroundColor = .clear

		// Misc.
		close.isMovableByWindowBackground = false
		close.isMovable = false

		// Add as child
		appDelegate.panel.addChildWindow(close, ordered: .above)
	}

	/// Resets the position of the close button
	func setPosition() {

		let panel: NSPanel = appDelegate.panel

		// Get position for panel
		let parentOriginY = panel.frame.origin.y
		let parentOriginX = panel.frame.origin.x

		let parentTop = parentOriginY + panel.frame.height
		let parentLeft = parentOriginX

		// Offset and finalize
		let offsetX: CGFloat = 5
		let offsetY: CGFloat = 6
		let topLeftOfPanel = NSPoint(x: parentLeft - offsetX, y: parentTop + offsetY)

		close.setFrameTopLeftPoint(topLeftOfPanel)
	}
}

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

	// ------------- Initialization ⤵︎ -------------

	init(_ panel: NSPanel) {

		// Get position for panel
		let parentTop = appDelegate.panel.frame.maxY
		let parentLeft = appDelegate.panel.frame.minX

		// Offset and set
		let offsetX: CGFloat = 5
		let offsetY: CGFloat = 2
		let topLeft = NSPoint(x: parentLeft - offsetX, y: parentTop - offsetY)
		panel.setFrameOrigin(topLeft)

		// Titlebar setup
		panel.titlebarAppearsTransparent = true
		panel.titleVisibility = .hidden

		// Aesthetics
		panel.alphaValue = 1.0
		panel.hasShadow = true

		// Animation
		panel.animationBehavior = .none

		// Assign content to panel
		panel.contentViewController = NSHostingController(rootView: PanelCloseButton())
		panel.isOpaque = true
		panel.backgroundColor = .clear

		// Misc.
		panel.isMovableByWindowBackground = false

		// Add as child
		appDelegate.panel.addChildWindow(panel, ordered: .above)
	}
}

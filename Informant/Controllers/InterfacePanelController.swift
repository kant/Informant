//
//  InterfacePanelController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-20.
//

import Foundation
import SwiftUI

class InterfacePanelController<Content: View> {

	let panel: NSPanel

	init(_ panelRef: NSPanel, _ contentView: Content) {

		// Assign ref.
		panel = panelRef

		// TODO: This needs to be adjusted so that it's actually in the center
		// Centers window in middle of screen on launch
		panel.center()

		// Hide the titlebar
		panel.titlebarAppearsTransparent = true
		panel.titleVisibility = .hidden

		// Hide all Titlebar Controls
		panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
		panel.standardWindowButton(.closeButton)?.isHidden = true
		panel.standardWindowButton(.zoomButton)?.isHidden = true

		// Brings window to the top level but not above the menubar
		panel.level = .floating
		panel.becomesKeyOnlyIfNeeded = true

		// Nice smooth exit
		panel.animationBehavior = .none

		// Other self explained window settings
		panel.isMovableByWindowBackground = true

		// Makes sure that the window can be reopened after being closed
		panel.isReleasedWhenClosed = false

		// Set the view controller
		panel.contentViewController = NSHostingController(rootView: contentView)
	}
}

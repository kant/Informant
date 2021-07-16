//
//  File.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-13.
//

import Foundation
import SwiftUI

class WelcomeWindowController {

	var window: NSInformantWindow
	var appDelegate: AppDelegate

	init(_ windowRef: NSInformantWindow) {

		window = windowRef
		appDelegate = AppDelegate.current()

		// Setup window
		window.titlebarAppearsTransparent = true

		// Hide toolbar controls
		window.standardWindowButton(.miniaturizeButton)?.isHidden = true
		window.standardWindowButton(.zoomButton)?.isHidden = true

		// Misc.
		window.isMovableByWindowBackground = true
		window.isReleasedWhenClosed = false

		// Animation
		window.animationBehavior = .default

		// Setup view
		window.contentViewController = NSHostingController(rootView: WelcomeAuthView())

		/*
		 // TODO: Remove from production
		 #warning("Remove this from production")
		 open()
		 */
		
		// Start authorization sequence
	}

	/// Opens up the settings window
	func open() {
		window.center()
		window.makeKeyAndOrderFront(nil)
		NSRunningApplication.current.activate(options: .activateIgnoringOtherApps)
	}
}

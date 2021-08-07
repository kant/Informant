//
//  SettingsWindowController.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-29.
//

import Foundation
import SwiftUI

class SettingsWindowController {

	var appDelegate: AppDelegate

	/// So we can maintain reference to the window
	var window: NSIFWindow

	// ------------- Initialization ⤵︎ -------------

	init(_ windowRef: NSIFWindow) {

		// Grab reference to the delegate & window
		appDelegate = AppDelegate.current()
		window = windowRef

		// Setup window
		window.titlebarAppearsTransparent = true

		// Misc.
		window.isMovableByWindowBackground = true
		window.isReleasedWhenClosed = false

		// Animation
		window.animationBehavior = .default

		// Setup view
		window.contentViewController = NSHostingController(rootView: SettingsView())

		// TODO: Remove from production
		/*
		 #warning("Remove this from production")
		  open()
		  */
	}

	/// Opens up the settings window
	func open() {
		window.center()
		window.makeKeyAndOrderFront(nil)
		NSRunningApplication.current.activate(options: .activateIgnoringOtherApps)
	}
}

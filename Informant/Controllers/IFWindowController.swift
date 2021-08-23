//
//  File.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-13.
//

import Foundation
import SwiftUI

class IFWindowController<Content: View> {

	var window: NSIFWindow
	var appDelegate: AppDelegate

	init(_ windowRef: NSIFWindow, _ rootView: Content) {

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
		window.contentViewController = NSHostingController(rootView: rootView)
	}

	/// Opens up the settings window
	func open() {
		window.center()
		window.makeKeyAndOrderFront(nil)
		NSRunningApplication.current.activate(options: .activateIgnoringOtherApps)
	}

	/// Closes down the window
	func close() {
		window.close()
	}
}

//
//  InterfaceAlert.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-14.
//

import Foundation
import SwiftUI

class InterfaceAlertController {

	let appDelegate: AppDelegate!
	let alert: NSPanel!

	@State private var alertShowing: Bool = false

	private let side: CGFloat = 176

	// ------------ Initialization ⤵︎ ---------------

	init() {

		// Grab delegate and alert panel reference
		appDelegate = AppDelegate.current()
		alert = appDelegate.interfaceAlert

		// Ensure titlebar is not visible
		alert.titlebarAppearsTransparent = true
		alert.titleVisibility = .hidden

		// Remove visible shadow
		alert.hasShadow = false

		// Set transparency
		alert.alphaValue = 1.0

		// Animation behaviour
		alert.animationBehavior = .none

		// Content view
		alert.contentViewController = NSHostingController(rootView: PanelAlert())
		alert.isOpaque = false
		alert.backgroundColor = .clear

		// Misc.
		alert.level = .floating
		alert.becomesKeyOnlyIfNeeded = true
		alert.isMovableByWindowBackground = false
		alert.ignoresMouseEvents = true

		// Position and size alert
		alert.setContentSize(getAlertSize())

		if let center = getAlertCenter() {
			alert.setFrameOrigin(center)
		}
	}

	/// Gets the alert's center based on size and screen size
	private func getAlertCenter() -> NSPoint? {

		// Make sure screen exists
		guard let screen = NSScreen.main else {
			return nil
		}

		// Calculate center
		let sideHalved: CGFloat = side / 2
		let x = screen.frame.midX - sideHalved
		let y = screen.frame.midY - sideHalved
		return NSPoint(x: x, y: y)
	}

	/// Gets the alert's size
	private func getAlertSize() -> CGSize {
		return CGSize(width: side, height: side)
	}

	/// Displays alert
	func showAlert() {

		// Find new center
		if let center = getAlertCenter() {
			alert.setFrameOrigin(center)
		}

		// Make sure alert is transparent before displaying
		if !alertShowing {
			alert.alphaValue = 0
			alert.setIsVisible(true)
		}

		// Animates the window from transparent to opaque
		NSAnimationContext.runAnimationGroup { (context) -> Void in
			context.duration = TimeInterval(0.2)
			alert.animator().alphaValue = 1
		} completionHandler: {
			self.beginHidingAlert()
			self.alertShowing = true
		}
	}

	/// Makes sure to wait for alpha of window to be at rest before hiding
	func beginHidingAlert() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
			if self.alert.alphaValue == 1 {
				self.hideAlert()
			}
		}
	}

	/// Hides alert
	func hideAlert() {

		// Make sure alpha is set to 1
		alert.alphaValue = 1

		// Animates the window from transparent to opaque
		NSAnimationContext.runAnimationGroup { (context) -> Void in
			context.duration = TimeInterval(0.2)
			alert.animator().alphaValue = 0
		} completionHandler: {
			self.alertShowing = false
			self.alert.setIsVisible(false)
		}
	}

	/// Shows alert and copies value to pasteboard
	func showCopyAlert(_ string: String, type: NSPasteboard.PasteboardType) {

		// Copy the value to the pasteboard
		let pasteboard = NSPasteboard.general
		pasteboard.declareTypes([type], owner: nil)
		pasteboard.setString(string, forType: type)

		// Show the alert
		showAlert()
	}
}

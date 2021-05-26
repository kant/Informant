//
//  InterfaceMenuHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-05-24.
//

import Foundation
import KeyboardShortcuts
import SwiftUI

class InterfaceMenuController {

	let appDelegate: AppDelegate!
	let menu: NSMenu!

	// Menu items
	var togglePanelMenuItem: NSMenuItem!
	var preferencesMenuItem: NSMenuItem!
	var quitMenuItem: NSMenuItem!

	// ------------ Initialization ⤵︎ ------------

	init() {
		// Grab app delegate
		appDelegate = AppDelegate.current()

		// Setup interface menu
		menu = appDelegate.interfaceMenu

		// Establish menu items
		togglePanelMenuItem = NSMenuItem(title: ContentManager.Labels.panelMenuToggleDetails, action: #selector(togglePanel), keyEquivalent: "")
		togglePanelMenuItem.target = self

		preferencesMenuItem = NSMenuItem(title: ContentManager.Labels.panelMenuPreferences, action: #selector(openPreferences), keyEquivalent: "")
		preferencesMenuItem.target = self

		// Quit application
		quitMenuItem = NSMenuItem(title: ContentManager.Labels.panelMenuQuit, action: #selector(quitApplication), keyEquivalent: "")
		quitMenuItem.target = self

		// Populate interface menu
		menu.addItem(togglePanelMenuItem)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(preferencesMenuItem)
		menu.addItem(quitMenuItem)

		// -------- Update shortcut preferences ---------
		togglePanelMenuItem.setShortcut(for: .togglePopover)
		togglePanelMenuItem.image = #imageLiteral(resourceName: "DocStretchedThree.png")
		togglePanelMenuItem.image?.isTemplate = true
		togglePanelMenuItem.image?.size = NSSize(width: 21, height: 24)
	}

	// MARK: - Menu Logic

	/// Pops up menu at the panel menu button.
	func openMenu() {

		// Find x & y coordinates
		let panelFrame = appDelegate.window.frame
		var x = panelFrame.maxX
		var y = panelFrame.minY

		// Offset coordinates
		y += 3.0
		x -= 30.0

		let coordinates = NSPoint(x: x, y: y)

		menu.popUp(positioning: nil, at: coordinates, in: nil)
	}

	/// Simply hides the panel
	@objc func togglePanel() {
		appDelegate.statusBarController?.hideWindow()
	}

	// TODO: Add preferences window
	/// Simply opens up the preferences window
	@objc func openPreferences() {
		print("Finish Preferences")
	}

	/// Quits application all together
	@objc func quitApplication() {
		NSApp.terminate(nil)
	}
}

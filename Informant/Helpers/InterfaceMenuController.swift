//
//  InterfaceMenuHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-05-24.
//

import Foundation
import SwiftUI

class InterfaceMenuController {

	let appDelegate: AppDelegate!
	let menu: NSMenu!

	// ------------ Initialization ⤵︎ ------------

	init() {
		// Grab app delegate
		appDelegate = AppDelegate.current()

		// Setup interface menu
		menu = appDelegate.interfaceMenu

		// Establish menu items
		let preferencesMenuItem = NSMenuItem()
		preferencesMenuItem.title = ContentManager.Labels.panelMenuPreferences

		let aboutMenuItem = NSMenuItem()
		aboutMenuItem.title = ContentManager.Labels.panelMenuAbout

		let helpMenuItem = NSMenuItem()
		helpMenuItem.title = ContentManager.Labels.panelMenuHelp

		let quitMenuItem = NSMenuItem()
		quitMenuItem.title = ContentManager.Labels.panelMenuQuit

		let seperatorMenuItem = NSMenuItem.separator()

		// Populate interface menu
		menu.addItem(preferencesMenuItem)
		menu.addItem(seperatorMenuItem)
		menu.addItem(aboutMenuItem)
		menu.addItem(helpMenuItem)
		menu.addItem(quitMenuItem)
	}

	// MARK: - Menu Logic

	func openMenu() {

		// Find x & y coordinates
		let panelFrame = appDelegate.window.frame
		var x = panelFrame.maxX
		var y = panelFrame.minY

		// Offset coordinates
		y += 3.0
		x -= 30.0

		let coordinates = NSPoint(x: x, y: y)

		menu.popUp(positioning: menu.items[0], at: coordinates, in: nil)
	}
}

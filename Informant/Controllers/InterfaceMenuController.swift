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
//	var togglePanelMenuItem: NSMenuItem!
	var pauseMenuItem: NSMenuItem!
	var menuBarUtilityMenuItem: NSMenuItem!
	var preferencesMenuItem: NSMenuItem!
	var quitMenuItem: NSMenuItem!

	// ------------ Initialization ⤵︎ ------------

	init() {
		// Grab app delegate
		appDelegate = AppDelegate.current()

		// Setup interface menu
		menu = appDelegate.interfaceMenu

		// Establish menu items
		pauseMenuItem = NSMenuItem(title: ContentManager.SettingsLabels.pause, action: #selector(pause), keyEquivalent: "")
		pauseMenuItem.target = self

		menuBarUtilityMenuItem = NSMenuItem(title: ContentManager.SettingsLabels.menubarUtilityShow, action: #selector(enableMenuBarUtility), keyEquivalent: "")
		menuBarUtilityMenuItem.target = self

		preferencesMenuItem = NSMenuItem(title: ContentManager.Labels.panelMenuPreferences, action: #selector(openPreferences), keyEquivalent: "")
		preferencesMenuItem.target = self

		// Quit application
		quitMenuItem = NSMenuItem(title: ContentManager.Labels.panelMenuQuit, action: #selector(quitApplication), keyEquivalent: "")
		quitMenuItem.target = self

		// Populate interface menu
		menu.addItem(pauseMenuItem)
		menu.addItem(menuBarUtilityMenuItem)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(preferencesMenuItem)
		menu.addItem(quitMenuItem)

		// Set size of menu
		menu.minimumWidth = 200
	}

	// MARK: - Menu Logic

	/// Updates the menu
	func updateMenu() {
		pauseMenuItem.manageState(setting: false) {
			pauseMenuItem.title = ContentManager.SettingsLabels.resume
			pauseMenuItem.setupImage("resume.png")
		} off: {
			pauseMenuItem.title = ContentManager.SettingsLabels.pause
			pauseMenuItem.setupImage("pause.png")
		}

		menuBarUtilityMenuItem.manageState(setting: appDelegate.interfaceState.settingsMenubarUtilityBool) {
			menuBarUtilityMenuItem.title = ContentManager.SettingsLabels.menubarUtilityHide.capitalized
			menuBarUtilityMenuItem.setupImage("hide.png")
		} off: {
			menuBarUtilityMenuItem.title = ContentManager.SettingsLabels.menubarUtilityShow.capitalized
			menuBarUtilityMenuItem.setupImage("show.png")
		}
	}

	/// Pops up menu at the panel menu button.
	func openMenuAtPanel() -> Bool {

		updateMenu()

		// Find x & y coordinates
		let panelFrame = appDelegate.panel.frame
		var x = panelFrame.maxX
		var y = panelFrame.minY

		// Offset coordinates
		y += 3.0
		x -= 30.0

		let coordinates = NSPoint(x: x, y: y)

		return menu.popUp(positioning: nil, at: coordinates, in: nil)
	}

	/*
	 /// Pops up the menu at the status item button.
	 func openMenuAtStatusItem() -> Bool {

	 	// Find x & y coordinates
	 	guard let statusFrame = appDelegate.panelStatusItem?.button?.window?.frame else {
	 		return false
	 	}

	 	var x = statusFrame.maxX
	 	var y = statusFrame.minY

	 	// Offset coordinates
	 	y += 3.0
	 	x -= 30.0

	 	let coordinates = NSPoint(x: x, y: y)

	 	return menu.popUp(positioning: nil, at: coordinates, in: nil)
	 }
	 */

	// Pause functionality
	@objc func pause() {
		pauseMenuItem.manageState(setting: false) {

		} off: {
		}
	}

	// Menu bar functionality
	@objc func enableMenuBarUtility() {
		menuBarUtilityMenuItem.manageState(setting: appDelegate.interfaceState.settingsMenubarUtilityBool) {
			appDelegate.interfaceState.settingsMenubarUtilityBool = false
		} off: {
			appDelegate.interfaceState.settingsMenubarUtilityBool = true
		}
	}

	/// Simply hides the panel
	@objc func togglePanel() {
		appDelegate.statusBarController?.hideInterfaces()
	}

	/// Simply opens up the preferences window
	@objc func openPreferences() {
		appDelegate.settingsWindowController?.open()
	}

	/// Quits application all together
	@objc func quitApplication() {
		NSApp.terminate(nil)
	}
}

//
//  SettingsUserDefaults.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import Foundation

extension AppDelegate {
	
	/// Sets defaults for user defaults
	func registerUserDefaults() {
		let userdefaults = UserDefaults.standard
		userdefaults.register(defaults: [
			
			// Menubar
			.keyMenubarShowSize: true,
			.keyMenubarShowKind: false,
			.keyMenubarShowCreated: false,
			.keyMenubarShowPath: false,
			
			// Panel
			.keyPanelHidePathProp: false,
			.keyPanelHideCreatedProp: false,
			.keyPanelHideNameProp: true,
			.keyPanelDisplayFullPath: false,
			
			// System
			.keySystemStartupBool: false,
			.keyMenubarUtilityBool: true,
			.keyPanelSkipDirectories: false,
			
			// Misc.
			.keyShowWelcomeWindow: true
		])
	}
}

/// Contains storage keys for user defaults
public extension String {
	
	static let keyRootURL = "rootURL"
	
	static let keyRootURLBookmarkData = "rootURLBookmarkData"
	
	static let keyMenubarShowSize = "menubarShowSize"
	
	static let keyMenubarShowKind = "menubarShowKind"
	
	static let keyMenubarShowCreated = "menubarShowCreated"
	
	static let keyMenubarShowPath = "menubarShowPath"
	
	static let keySystemStartupBool = "systemStartupBool"
	
	static let keyMenubarUtilityBool = "menubarUtilityBool"
	
	static let keyPanelDisplayFullPath = "panelShowFullPath"
	
	static let keyPanelSkipDirectories = "panelSkipDirectories"
	
	static let keyPanelHideNameProp = "panelEnableNameProp"
	
	static let keyPanelHidePathProp = "panelEnablePathProp"
	
	static let keyPanelHideCreatedProp = "panelEnableCreatedProp"
	
	static let keyShowWelcomeWindow = "welcomeWindowShow"
}

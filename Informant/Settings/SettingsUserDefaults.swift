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
			.keyMenubarShowDuration: false,
			.keyMenubarShowDimensions: false,
			.keyMenubarShowCodecs: false,
			.keyMenubarShowItems: false,
			.keyMenubarIcon: ContentManager.MenubarIcons.menubarDefault,
			
			// Panel
			.keyPanelHidePathProp: false,
			.keyPanelHideCreatedProp: false,
			.keyPanelHideNameProp: true,
			.keyPanelHideIconProp: false,
			.keyPanelDisplayFullPath: false,
			
			// System
			.keySystemStartupBool: false,
			.keyMenubarUtilityBool: true,
			.keyPanelSkipDirectories: false,
			
			// Misc.
			.keyShowWelcomeWindow: true,
			.keyPauseApp: false
		])
	}
}

/// Contains storage keys for user defaults
public extension String {
	
	static let keyRootURL = "rootURL"
	
	static let keyRootURLBookmarkData = "rootURLBookmarkData"
	
	static let keyPauseApp = "pauseApp"
	
	static let keyMenubarShowSize = "menubarShowSize"
	
	static let keyMenubarShowKind = "menubarShowKind"
	
	static let keyMenubarShowDuration = "menubarShowDuration"
	
	static let keyMenubarShowDimensions = "menubarShowDimensions"
	
	static let keyMenubarShowCodecs = "menubarShowCodecs"
	
	static let keyMenubarShowItems = "menubarShowItems"
	
	static let keyMenubarIcon = "menubarIcon"
	
	static let keySystemStartupBool = "systemStartupBool"
	
	static let keyMenubarUtilityBool = "menubarUtilityBool"
	
	static let keyPanelDisplayFullPath = "panelShowFullPath"
	
	static let keyPanelSkipDirectories = "panelSkipDirectories"
	
	static let keyPanelHideNameProp = "panelHideNameProp"
	
	static let keyPanelHidePathProp = "panelHidePathProp"
	
	static let keyPanelHideCreatedProp = "panelHideCreatedProp"
	
	static let keyPanelHideIconProp = "panelHideIconProp"
	
	static let keyShowWelcomeWindow = "welcomeWindowShow"
}

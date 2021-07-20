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
			.keySystemStartupBool: false,
			.keyMenubarUtilityBool: true,
			.keyPanelEnablePathProp: true,
			.keyPanelEnableCreatedProp: true,
			.keyPanelEnableNameProp: false,
			.keyPanelShowFullPath: true,
			.keyShowWelcomeWindow: true
		])
	}
}

/// Contains storage keys for user defaults
public extension String {
	
	static let keyRootURL = "rootURL"
	
	static let keyRootURLBookmarkData = "rootURLBookmarkData"
	
	static let keySystemStartupBool = "systemStartupBool"
	
	static let keyMenubarUtilityBool = "menubarUtilityBool"
	
	static let keyPanelShowFullPath = "panelShowFullPath"
	
	static let keyPanelEnableNameProp = "panelEnableNameProp"
	
	static let keyPanelEnablePathProp = "panelEnablePathProp"
	
	static let keyPanelEnableCreatedProp = "panelEnableCreatedProp"
	
	static let keyShowWelcomeWindow = "welcomeWindowShow"
}

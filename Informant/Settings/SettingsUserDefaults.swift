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
			.keyMenubarShowModified: false,
			
			.keyMenubarShowDuration: false,
			.keyMenubarShowDimensions: false,
			.keyMenubarShowCodecs: false,
			.keyMenubarShowColorProfile: false,
			.keyMenubarShowVideoBitrate: false,
			
			.keyMenubarShowItems: false,
			
			.keyMenubarShowVersion: false,
			
			.keyMenubarShowSampleRate: false,
			.keyMenubarShowAudioBitrate: false,
			
			.keyMenubarShowVolumeTotal: false,
			.keyMenubarShowVolumeAvailable: false,
			.keyMenubarShowVolumePurgeable: false,
			
			.keyMenubarShowAperture: false,
			.keyMenubarShowISO: false,
			.keyMenubarShowFocalLength: false,
			.keyMenubarShowCamera: false,
			.keyMenubarShowShutterSpeed: false,
			
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
	
	// MARK: - Menu Bar Settings
	
	// General
	static let keyMenubarShowSize = "menubarShowSize"
	
	static let keyMenubarShowKind = "menubarShowKind"
	
	static let keyMenubarShowCreated = "menubarShowCreated"
	
	static let keyMenubarShowModified = "menubarShowModified"
	
	// Media
	static let keyMenubarShowDuration = "menubarShowDuration"
	
	static let keyMenubarShowDimensions = "menubarShowDimensions"
	
	static let keyMenubarShowCodecs = "menubarShowCodecs"
	
	static let keyMenubarShowColorProfile = "menubarShowColorProfile"
	
	static let keyMenubarShowVideoBitrate = "menubarShowVideoBitrate"
	
	// Directory
	static let keyMenubarShowItems = "menubarShowItems"
	
	// Application
	static let keyMenubarShowVersion = "menubarShowVersion"
	
	// Audio
	static let keyMenubarShowSampleRate = "menubarShowSampleRate"
	
	static let keyMenubarShowAudioBitrate = "menubarShowAudioBitrate"
	
	// Volume
	static let keyMenubarShowVolumeTotal = "menubarShowVolumeTotal"
	
	static let keyMenubarShowVolumeAvailable = "menubarShowAvailable"
	
	static let keyMenubarShowVolumePurgeable = "menubarShowVolumePurgeable"
	
	// Images
	static let keyMenubarShowAperture = "menubarShowAperture"
	
	static let keyMenubarShowISO = "menubarShowISO"
	
	static let keyMenubarShowFocalLength = "menubarShowFocalLength"
	
	static let keyMenubarShowCamera = "menubarShowCamera"
	
	static let keyMenubarShowShutterSpeed = "menubarShowShutterSpeed"
	
	// MARK: - System Settings
	
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

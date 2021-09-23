//
//  InterfaceObservable.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-07.
//

import Foundation
import SwiftUI

/// Parameters can be added here that need to be observed for the content view
class InterfaceState: ObservableObject {

	// MARK: - Interface State
	/// Detects if the panel itself is in the panel snap zone
	@Published var isPanelInSnapZone: Bool = false

	/// Helper designed to set the in snap zone of panel
	public func setIsPanelInSnapZone(_ value: Bool) {
		isPanelInSnapZone = value
	}

	/// Keeps track of state of path switch
	@Published var isPathExpanded: Bool = false

	public func setIsPathExpanded(_ value: Bool) {
		isPathExpanded = value
	}

	/// Keeps track of whether the mouse is hovering on the panel
	@Published var isMouseHoveringPanel: Bool = false

	@Published var isMouseHoveringClose: Bool = false

	/// Hover zones for the close button
	public enum CloseHoverZones {
		case Button
		case Panel
	}

	/// Keeps track of which hover zone the mouse is in
	@Published var closeHoverZone: CloseHoverZones?

	// MARK: - Privacy Data

	/// Lets us know the state of accessibility permission
	@Published var privacyAccessibilityEnabled: Bool? = AXIsProcessTrusted()

	// MARK: - Settings Data

	@Published var settingsRootURL: String? = UserDefaults.standard.string(forKey: .keyRootURL) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyRootURL)
		}
	}

	@Published var settingsSystemStartupBool: Bool = UserDefaults.standard.bool(forKey: .keySystemStartupBool) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keySystemStartupBool)
		}
	}

	@Published var settingsMenubarUtilityBool: Bool = UserDefaults.standard.bool(forKey: .keyMenubarUtilityBool) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarUtilityBool)
		}

		didSet {
			// Check current visibility
			AppDelegate.current().statusBarController?.checkMenubarUtilitySettings()
		}
	}

	@Published var settingsPanelDisplayFullPath: Bool = UserDefaults.standard.bool(forKey: .keyPanelDisplayFullPath) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelDisplayFullPath)
		}
	}

	@Published var settingsPanelSkipDirectories: Bool = UserDefaults.standard.bool(forKey: .keyPanelSkipDirectories) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelSkipDirectories)
		}
	}

	@Published var settingsPanelHideNameProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelHideNameProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelHideNameProp)
		}
	}

	@Published var settingsPanelHidePathProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelHidePathProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelHidePathProp)
		}
	}

	@Published var settingsPanelHideCreatedProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelHideCreatedProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelHideCreatedProp)
		}
	}

	@Published var settingsPanelHideIconProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelHideIconProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelHideIconProp)
		}
	}

	@Published var settingsPauseApp: Bool = UserDefaults.standard.bool(forKey: .keyPauseApp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPauseApp)
		}

		didSet(value) {
			if value == false {
				MenubarUtilityHelper.wipeMenubarInterface()
			} else {
				AppDelegate.current().statusBarController?.updateInterfaces()
			}
		}
	}

	// MARK: - Menu Bar Settings

	// MARK: General
	@Published var settingsMenubarShowSize: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowSize) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowSize)
		}

		didSet {
			MenubarUtilityHelper.update(force: true)
		}
	}

	@Published var settingsMenubarShowKind: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowKind) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowKind)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowCreated: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowCreated) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowCreated)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowModified: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowModified) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowModified)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// MARK: - Media
	@Published var settingsMenubarShowDuration: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowDuration) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowDuration)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowDimensions: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowDimensions) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowDimensions)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowCodecs: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowCodecs) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowCodecs)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowColorProfile: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowColorProfile) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowColorProfile)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowVideoBitrate: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowVideoBitrate) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowVideoBitrate)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// MARK: - Directory
	@Published var settingsMenubarShowItems: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowItems) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowItems)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// MARK: - Application
	@Published var settingsMenubarShowVersion: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowVersion) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowVersion)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// MARK: - Audio
	@Published var settingsMenubarShowSampleRate: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowSampleRate) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowSampleRate)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowAudioBitrate: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowAudioBitrate) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowAudioBitrate)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// MARK: - Volume
	@Published var settingsMenubarShowVolumeTotal: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowVolumeTotal) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowVolumeTotal)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowVolumeAvailable: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowVolumeAvailable) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowVolumeAvailable)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowVolumePurgeable: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowVolumePurgeable) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowVolumePurgeable)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// MARK: - Images
	@Published var settingsMenubarShowAperture: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowAperture) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowAperture)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowISO: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowISO) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowISO)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowFocalLength: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowFocalLength) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowFocalLength)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowCamera: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowCamera) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowCamera)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	@Published var settingsMenubarShowShutterSpeed: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowShutterSpeed) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowShutterSpeed)
		}

		didSet {
			MenubarUtilityHelper.update()
		}
	}

	// System
	@Published var settingsMenubarIcon: String = UserDefaults.standard.string(forKey: .keyMenubarIcon) ?? ContentManager.MenubarIcons.menubarDefault {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarIcon)
		}

		didSet {
			MenubarUtilityHelper.updateIcon()
			MenubarUtilityHelper.update()
		}
	}
}

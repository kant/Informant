//
//  InterfaceObservable.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-07.
//

import Foundation

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

	// ------------ Menubar Settings ------------- ⤵︎

	@Published var settingsMenubarShowSize: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowSize) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowSize)
		}
	}

	@Published var settingsMenubarShowKind: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowKind) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowKind)
		}
	}

	@Published var settingsMenubarShowDuration: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowDuration) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowDuration)
		}
	}

	@Published var settingsMenubarShowDimensions: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowDimensions) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowDimensions)
		}
	}

	@Published var settingsMenubarShowPath: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowPath) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowPath)
		}
	}

	@Published var settingsMenubarShowFullPath: Bool = UserDefaults.standard.bool(forKey: .keyMenubarShowFullPath) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyMenubarShowFullPath)
		}
	}
}

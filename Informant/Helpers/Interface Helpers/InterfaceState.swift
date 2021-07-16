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

	@Published var settingsPanelShowFullPath: Bool = UserDefaults.standard.bool(forKey: .keyPanelShowFullPath) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelShowFullPath)
		}
	}

	@Published var settingsPanelEnableNameProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelEnableNameProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelEnableNameProp)
		}
	}

	@Published var settingsPanelEnablePathProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelEnablePathProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelEnablePathProp)
		}
	}

	@Published var settingsPanelEnableCreatedProp: Bool = UserDefaults.standard.bool(forKey: .keyPanelEnableCreatedProp) {
		willSet(value) {
			UserDefaults.standard.setValue(value, forKey: .keyPanelEnableCreatedProp)
		}
	}
}

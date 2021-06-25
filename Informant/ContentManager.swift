//
//  LocalizableTriage.swift
//  Informant
//
//  Created by Ty Irvine on 2021-05-23.
//

import Foundation

/// This class is used to reduce the use of hard-coded strings in the source
class ContentManager {

	// MARK: - Messages

	public enum Messages {

		static let setupAccessibilityNotEnabled = NSLocalizedString("Access Not Enabled", comment: "The message that appears if the user declines accessibility access.")
	}

	// MARK: - Labels

	public enum Labels {

		// Misc. Labels
		static let multiSelectTitle = NSLocalizedString("items selected", comment: "The tag string to go on a multi-selection title in the panel")

		static let multiSelectSize = NSLocalizedString("Total Size:", comment: "The tag string under the title of the multi-selection panel")

		static let panelSnapZoneIndicator = NSLocalizedString("Release to snap", comment: "The indicator label when dragging the panel near the snap zone")

		// Panel Labels
		static let panelNoItemsSelected = NSLocalizedString("No items selected", comment: "String displayed when no items are selected.")

		static let panelKind = NSLocalizedString("Kind", comment: "This is the file's kind displayed in the panel")

		static let panelSize = NSLocalizedString("Size", comment: "This is the file's size displayed in the panel")

		static let panelCreated = NSLocalizedString("Created", comment: "This is the file's creation date displayed in the panel")

		static let panelPath = NSLocalizedString("Path", comment: "This is the file's path displayed in the panel")

		static let panelExpandedPath = NSLocalizedString("Expanded Path", comment: "This is the label that appears after clicking the path label on the panel")

		static let panelModified = NSLocalizedString("Edited", comment: "The tag string to the date modified on the panel interface")

		static let panelCamera = NSLocalizedString("Camera", comment: "Camera, Used on panel image view and movie")

		static let panelFocalLength = NSLocalizedString("Focal Length", comment: "Focal Length, Used on panel image view and movie")

		static let panelDimensions = NSLocalizedString("Dimensions", comment: "Dimensions, Used on panel image view and movie")

		static let panelColorProfile = NSLocalizedString("Color Profile", comment: "Color Profile, Used on panel image view and movie")

		static let panelAperture = NSLocalizedString("Aperture", comment: "Aperture, Used on panel image view and movie")

		static let panelExposure = NSLocalizedString("Exposure", comment: "Exposure, Used on panel image view and movie")

		static let panelCodecs = NSLocalizedString("Codecs", comment: "Codecs, Used on panel movie view")

		static let panelDuration = NSLocalizedString("Duration", comment: "Duration, Used on panel movie & audio view")

		static let panelSampleRate = NSLocalizedString("Sample Rate", comment: "Sample rate, Used on panel audio view")

		static let panelContains = NSLocalizedString("Contains", comment: "Contains, Used on the panel directory view")

		static let panelVersion = NSLocalizedString("Version", comment: "Version, Used on panel application view")

		// Panel Menu Labels
		static let panelMenuPreferences = NSLocalizedString("Preferences...", comment: "Preferences menu item in panel menu")

		static let panelMenuAbout = NSLocalizedString("About", comment: "About menu item in panel menu")

		static let panelMenuHelp = NSLocalizedString("Help", comment: "Help menu item in panel menu")

		static let panelMenuQuit = NSLocalizedString("Quit", comment: "Quit menu item in panel menu")

		static let panelMenuToggleDetails = NSLocalizedString("Toggle Panel", comment: "Toggle panel menu item in panel menu")

		// Preferences Labels
		static let preferencesShortcutsDisplayDetailPanel = NSLocalizedString("Display detail panel", comment: "Shortcut label for displaying panel")
	}

	// MARK: - Icons

	public enum Icons {

		static let menuBar = "menubar-icon"

		static let panelHideButton = "xmark"

		static let panelPreferencesButton = "gear"

		static let panelPathIcon = "􀤂"

		static let panelCopyIcon = "􀐅"

		/// The image size of the icon. This is scaled up so the icon looks better scaled down
		static let panelHeaderIconSize = NSSize(width: 128, height: 128)
	}

	// MARK: - Extra

	public enum Extra {

		static let items = NSLocalizedString("items", comment: "Items, used in the single directory selection")

		static let item = NSLocalizedString("item", comment: "Singular version of items")
	}
}

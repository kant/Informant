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

		static let settingsRootURLDescriptor = NSLocalizedString(
			"Required inorder to display additional metadata and the size of a directory. Choose Macintosh HD.",
			comment: ""
		)
	}

	// MARK: - Titles
	public enum Titles {

		static let panelNoItemsSelected = NSLocalizedString("Nothing selected", comment: "String displayed when no items are selected.")

		static let panelErrorTitle = NSLocalizedString("Can't get selection", comment: "The title displayed when the selection errors out")

		static let openPanelGrantAccess = NSLocalizedString("Grant Access", comment: "Open panel's grant access button label")
	}

	// MARK: - Colors
	public enum Colors {

		static let Red = NSLocalizedString("Red", comment: "The colour Red")

		static let Orange = NSLocalizedString("Orange", comment: "The colour Orange")

		static let Yellow = NSLocalizedString("Yellow", comment: "The colour Yellow")

		static let Green = NSLocalizedString("Green", comment: "The colour Green")

		static let Blue = NSLocalizedString("Blue", comment: "The colour Blue")

		static let Purple = NSLocalizedString("Purple", comment: "The colour Purple")

		static let Gray = NSLocalizedString("Gray", comment: "The colour Gray")
	}

	// MARK: - Welcome Labels
	public enum WelcomeLabels {

		// Authorization labels
		static let authorizeInformant = NSLocalizedString("Authorize Informant", comment: "Used on authorization welcome screen")

		static let authorizeNeedPermission = NSLocalizedString("Informant needs your permission to read file metadata.", comment: "Used on the authorize panel, it's the body string")

		// Authorization instruction labels
		static let authorizedInstructionSystemPreferences = NSLocalizedString("Open System Preferences", comment: "Used on auth instructions")

		static let authorizedInstructionSecurity = NSLocalizedString("Click Security & Privacy", comment: "Used on auth instructions")

		static let authorizedInstructionPrivacy = NSLocalizedString("Click Privacy", comment: "Used on auth instructions")

		static let authorizedInstructionScrollAndClick = NSLocalizedString("Scroll down and click Accessibility", comment: "Used on auth instructions")

		static let authorizedInstructionCheckInformant = NSLocalizedString("Check Informant", comment: "Used on auth instructions")

		// Auth. Padlock tidbit
		static let authorizedInstructionClickLock = NSLocalizedString("If the checkbox is greyed out, click the lock and enter your password.", comment: "Used on authorized welcome panel")

		// Welcome labels
		static let welcomeReadyToUse = NSLocalizedString("You're ready to use Informant!", comment: "Used on welcome panel")

		static let welcomeHowToUse = NSLocalizedString("To use Informant, select a file, and its size will appear in the menu bar.", comment: "Used on welcome panel")
	}

	// MARK: - Settings Labels
	public enum SettingsLabels {

		static let panel = NSLocalizedString("Panel", comment: "")

		static let system = NSLocalizedString("System", comment: "")

		static let privacyPolicy = NSLocalizedString("Privacy Policy", comment: "")

		static let feedback = NSLocalizedString("Feedback", comment: "")

		static let help = NSLocalizedString("Help", comment: "")

		static let none = NSLocalizedString("None", comment: "")

		static let pickRootURL = NSLocalizedString("Disk Path:", comment: "Pick the root url used to give security access to the app.")

		static let shortcutToActivatePanel = NSLocalizedString("Shortcut to activate panel", comment: "Asks the user what shortcut they want to activate the panel")

		static let launchOnStartup = NSLocalizedString("Launch Informant on system startup", comment: "Asks the user if they want the app to launch on startup")

		static let menubarUtility = NSLocalizedString("Enable menubar-utility", comment: "Asks the user if they want the menubar-utility enabled")

		static let toggleDetailsPanel = NSLocalizedString("Toggle panel shortcut:", comment: "Asks the user what shortcut they want to toggle the details panel")

		static let showFullPath = NSLocalizedString("Show full-path", comment: "Asks the user if they want to see where the file is located instead of the full path")

		static let enableName = NSLocalizedString("Enable name property", comment: "")

		static let enablePath = NSLocalizedString("Enable path property", comment: "")

		static let enableCreated = NSLocalizedString("Enable created property", comment: "")
	}

	// MARK: - State
	public enum State {

		static let unavailable = NSLocalizedString("Unavailable", comment: "Used when calculating a property but it's not there")

		static let calculating = NSLocalizedString("Calculating...", comment: "Used when calculating a property")

		static let finished = NSLocalizedString("Finished", comment: "Used when calculating a property has come to end")
	}

	// MARK: - Labels
	public enum Labels {

		// Misc. Labels
		static let multiSelectTitle = NSLocalizedString("items selected", comment: "The tag string to go on a multi-selection title in the panel")

		static let multiSelectSize = NSLocalizedString("Total Size:", comment: "The tag string under the title of the multi-selection panel")

		static let panelSnapZoneIndicator = NSLocalizedString("Release to snap", comment: "The indicator label when dragging the panel near the snap zone")

		// Panel Labels

		static let panelKind = NSLocalizedString("Kind", comment: "This is the file's kind displayed in the panel")

		static let panelSize = NSLocalizedString("Size", comment: "This is the file's size displayed in the panel")

		static let panelCreated = NSLocalizedString("Created", comment: "This is the file's creation date displayed in the panel")

		static let panelName = NSLocalizedString("Name", comment: "This is the file's name displayed on the panel")

		static let panelPath = NSLocalizedString("Path", comment: "This is the file's path displayed in the panel")

		static let panelWhere = NSLocalizedString("Where", comment: "This is the file's where path displayed in the panel")

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

		static let panelAvailable = NSLocalizedString("Available", comment: "Available, Used on panel volume view")

		static let panelTotal = NSLocalizedString("Total", comment: "Total, Used on volume panel view")

		static let panelPurgeable = NSLocalizedString("Purgeable", comment: "Purgeable, Used on volume panel view")

		static let panelTags = NSLocalizedString("Tags", comment: "Used on tags panel view")

		static let panelHidden = NSLocalizedString("Hidden", comment: "Used on bottom of the panel view to indicate a hidden file")

		static let panelUnauthorized = NSLocalizedString("Unauthorized", comment: "Used on panel when accessibility api is disabled")

		static let panelAuthorized = NSLocalizedString("Authorized", comment: "Used on panel when accessibility api is disabled")

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

		static let popUpCopied = NSLocalizedString("Copied", comment: "Used on the copied popup")
	}

	// MARK: - Images
	public enum Images {

		static let appIcon = "AppIcon"
	}
}

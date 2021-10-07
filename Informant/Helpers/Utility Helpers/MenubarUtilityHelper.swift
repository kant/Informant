//
//  MenubarUtilityHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-08.
//

import Foundation
import SwiftUI

/// This is just a collection of static functions to help with manipulating the menubar utility
class MenubarUtilityHelper {
	
	/// Establishes reference to the status item we want to use
	static let statusItem = AppDelegate.current().panelStatusItem
	
	/// Update utility size
	static func update(force: Bool = false) {
		
		// Grab reference to the appdelegate
		let appDelegate = AppDelegate.current()
		
		/// Gets the state of the selection and if it's a duplicate
		guard let checkedSelection = appDelegate.menubarInterfaceHelper.GetFinderSelection() else {
			return wipeMenubarInterface()
		}
		
		// Get the paths
		guard let paths = checkedSelection.selection.paths else {
			return wipeMenubarInterface()
		}
		
		// Error selection found
		if checkedSelection.state == .errorSelection {
			return wipeMenubarInterface()
		}
		
		// Make sure there's only one path selected and that it's not empty
		else if paths[0].isEmpty == true || paths.count > 1 {
			return wipeMenubarInterface()
		}
		
		// Duplicate selection found
		else if force == false, checkedSelection.state == .duplicateSelection {
			return updateMenubarInterface(url: URL(fileURLWithPath: paths[0]))
		}
		
		// Unique selection found
		else {
			
			// Get URL
			let url = URL(fileURLWithPath: paths[0])
			
			updateMenubarInterface(url: url)
		}
	}
	
	/// Updates the status item
	static func updateMenubarInterface(url: URL) {
		
		// Get a reference to the appdelegate
		let appDelegate = AppDelegate.current()
		
		// Figure out which parameters to include in the selection based on user settings
		var parameters: [SelectionParameters] = []
		
		if appDelegate.interfaceState.settingsMenubarShowSize {
			parameters.append(.grabSize)
		}
		
		// Find the selection with the desired parameters
		let selection = SelectionHelper.pickSingleSelectionType([url.path], parameters: parameters)
		
		// Formats the menubar's interface as a string and updates interface data held in memory
		appDelegate.menubarInterfaceSelection = selection
		appDelegate.menubarInterface = gatherMetadataForMenubar(selection: selection)
		
		updateAndDisplayMenubarInterface()
	}
	
	/// Gathers all metadata needed for the menu bar
	static func gatherMetadataForMenubar(selection: SelectionProtocol?) -> String? {
		
		// Get a reference to the appdelegate
		let appDelegate = AppDelegate.current()
		
		// Get a reference to settings
		guard let interfaceState = appDelegate.interfaceState else {
			return nil
		}
		
		// TODO: I know this isn't the best solution and this could use some work
		// General
		var size: String?
		var kind: String?
		var created: String?
		var modified: String?
		
		// Directory
		var items: String?
		
		// Application
		var version: String?
		
		// Media
		var dimensions: String?
		var duration: String?
		var codecs: String?
		var colorProfile: String?
		var videoBitrate: String?
		
		// Audio
		var sampleRate: String?
		var audioBitrate: String?
		
		// Volume
		var volumeTotal: String?
		var volumeAvailable: String?
		var volumePurgeable: String?
		
		// Images
		var aperture: String?
		var iso: String?
		var focalLength: String?
		var camera: String?
		var shutterSpeed: String?
		
		// MARK: - Verify & Format Size
		
		// Check to make sure the menu bar utility isn't disabled
		if interfaceState.settingsMenubarUtilityBool == false {
			return nil
		}

		// Confirm that we want to see size
		if interfaceState.settingsMenubarShowSize {
			
			// Filter out unavailable and calculating messages
			if selection?.itemSizeAsString == SelectionHelper.State.Finding.localized {
				size = ContentManager.State.findingNoPeriods
			}
			else if selection?.itemSizeAsString == SelectionHelper.State.Unavailable.localized {
				size = ""
			}
			else {
				size = selection?.itemSizeAsString
			}
		}
		
		// MARK: - Collect URL Resources
		
		// TODO: I know this is horrible and each setting should be checked in the properties loop instead but I didn't have much time to build this.
		// Assign values based on the type and whether they're wanted by the user.
		switch selection?.selectionType {
			
			case .Application:
				let cast = selection as? SingleApplicationSelection
				
				if interfaceState.settingsMenubarShowVersion, let versionUnwrapped = cast?.version {
					version = "\(ContentManager.SettingsLabels.menubarShowVersion) \(versionUnwrapped)"
				}
				break
				
			case .Audio:
				let cast = selection as? SingleAudioSelection
				
				if interfaceState.settingsMenubarShowDuration {
					duration = cast?.duration
				}
				
				if interfaceState.settingsMenubarShowSampleRate {
					sampleRate = cast?.sampleRate
				}
				
				if interfaceState.settingsMenubarShowAudioBitrate {
					audioBitrate = cast?.audioBitrate
				}
				break
				
			case .Image:
				let cast = selection as? SingleImageSelection
				
				if interfaceState.settingsMenubarShowDimensions {
					dimensions = cast?.dimensions
				}
				
				if interfaceState.settingsMenubarShowColorProfile {
					colorProfile = cast?.colorProfile
				}

				if interfaceState.settingsMenubarShowAperture {
					aperture = cast?.aperture
				}
				
				if interfaceState.settingsMenubarShowISO, let isoUnwrapped = cast?.iso {
					iso = "ISO \(isoUnwrapped)"
				}
				
				if interfaceState.settingsMenubarShowFocalLength {
					focalLength = cast?.focalLength
				}
				
				if interfaceState.settingsMenubarShowCamera {
					camera = cast?.camera
				}
				
				if interfaceState.settingsMenubarShowShutterSpeed {
					shutterSpeed = cast?.shutterSpeed
				}
				break
				
			case .Movie:
				let cast = selection as? SingleMovieSelection
				
				if interfaceState.settingsMenubarShowDimensions {
					dimensions = cast?.dimensions
				}
				
				if interfaceState.settingsMenubarShowDuration {
					duration = cast?.duration
				}
				
				if interfaceState.settingsMenubarShowCodecs {
					codecs = cast?.codecs
				}
				
				if interfaceState.settingsMenubarShowColorProfile {
					colorProfile = cast?.colorProfile
				}
				
				if interfaceState.settingsMenubarShowVideoBitrate, let videoBitrateUnwrapped = cast?.videoBitrate {
					videoBitrate = "\(ContentManager.SettingsLabels.video) \(videoBitrateUnwrapped)"
				}
				
				if interfaceState.settingsMenubarShowAudioBitrate, let audioBitrateUnwrapped = cast?.audioBitrate {
					audioBitrate = "\(ContentManager.SettingsLabels.audio) \(audioBitrateUnwrapped)"
				}
				
				break
				
			case .Volume:
				let cast = selection as? SingleVolumeSelection
				
				if interfaceState.settingsMenubarShowVolumeTotal, let total = cast?.totalCapacity {
					volumeTotal = "\(ContentManager.SettingsLabels.menubarShowVolumeTotal) \(total)"
				}
				
				if interfaceState.settingsMenubarShowVolumeAvailable, let available = cast?.availableCapacity {
					volumeAvailable = "\(ContentManager.SettingsLabels.menubarShowVolumeAvailable) \(available)"
				}
				
				if interfaceState.settingsMenubarShowVolumePurgeable, let purgeable = cast?.purgeableCapacity {
					volumePurgeable = "\(ContentManager.SettingsLabels.menubarShowVolumePurgeable) \(purgeable)"
				}
				break
			
			case .Directory:
				let cast = selection as? SingleDirectorySelection
				
				if interfaceState.settingsMenubarShowItems {
					items = cast?.itemCount
				}
				break
			
			default:
				break
		}
		
		// Cast as a single selection
		let general = selection as? SingleSelection
		
		if interfaceState.settingsMenubarShowKind {
			kind = general?.itemKind
		}
		
		if interfaceState.settingsMenubarShowCreated, let date = general?.itemDateCreatedAsString {
			created = "\(ContentManager.SettingsLabels.menubarShowCreated) \(date)"
		}

		if interfaceState.settingsMenubarShowModified {
			modified = general?.itemDateModifiedAsString
		}
		
		// MARK: - Assemble Final View For Util.
		
		// TODO: Find a cleaner approach to this
		// Collect all values
		let properties = [
		
			// General
			size,
			kind,
			created,
			modified,
			
			// Directory
			items,
			
			// Application
			version,
			
			// Media
			dimensions,
			duration,
			codecs,
			colorProfile,
			videoBitrate,
			
			// Audio
			sampleRate,
			audioBitrate,
			
			// Volume
			volumeTotal,
			volumeAvailable,
			volumePurgeable,
			
			// Images
			camera,
			shutterSpeed,
			focalLength,
			aperture,
			iso,
		]
		
		// Prepare the formatted string for the view
		return formatProperties(properties)
	}
	
	/// Simply updates the interface without updating the data
	static func updateAndDisplayMenubarInterface() {
		
		let appDelegate = AppDelegate.current()
		let selection = appDelegate.menubarInterfaceSelection
		
		// Prepare the formatted string for the view
		guard let formattedString = gatherMetadataForMenubar(selection: selection) else {
			return
		}
		
		// Get formatted fonts ready
		let font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
		
		// Creates a left justified paragraph style. Makes sure size (102 KB or whatever) stays to the left of the status item
		let paragraphStyle = NSMutableParagraphStyle()
		
		// Check icon style
		if appDelegate.interfaceState.settingsMenubarIcon == ContentManager.MenubarIcons.menubarBlank {
			paragraphStyle.alignment = .center
		}
		else {
			paragraphStyle.alignment = .left
		}
		
		// Put the attributed string all together
		let attrString = NSAttributedString(string: formattedString, attributes: [.font: font, .baselineOffset: -0.5, .paragraphStyle: paragraphStyle])
		
		// Update the size
		statusItem?.button?.attributedTitle = attrString
		
		shouldMenubarUtilityAppearDisabled()
	}
	
	/// For when there's no size available
	static func wipeMenubarInterface(resetState: Bool = false) {
		
		let appDelegate = AppDelegate.current()
		
		shouldMenubarUtilityAppearDisabled()
		
		statusItem?.button?.attributedTitle = NSAttributedString(string: "")
		
		if resetState == true {
			appDelegate.menubarInterface = ""
			appDelegate.menubarInterfaceSelection = nil
		}
	}
	
	// MARK: - Helper Functions
	
	/// Checks to see if the app is paused, and if so updates the menu bar utility interface accordingly
	static func shouldMenubarUtilityAppearDisabled() {
		if AppDelegate.current().interfaceState.settingsPauseApp {
			statusItem?.button?.appearsDisabled = true
		}
		else {
			statusItem?.button?.appearsDisabled = false
		}
	}
	
	/// Formats a collected property. Adds spaces and dividers when a value is present, otherwise it returns a blank string
	static func formatProperties(_ props: [String?]) -> String {
		
		var finalString: String = ""
		
		let finalStringSpacing = "  "
		
		// Filter out properties
		let propertiesNoEmpties = props.filter { $0 != "" }
		let propertiesNoNil = propertiesNoEmpties.compactMap { $0 }
		let properties = propertiesNoNil
		
		// If only one property is present then don't loop through
		if properties.count == 1 {
			finalString.append("\(properties[0] + finalStringSpacing)")
		}
		
		// Otherwise cycle all the properties to build the final string
		else {
			
			for (index, property) in properties.enumerated() {
				
				switch index {
				
					// First property
					case 0: finalString.append("\(property)  •")
						break
				
					// Last property
					case properties.count - 1: finalString.append("  \(property + finalStringSpacing)")
						break
					
					// Middle property
					default: finalString.append("  \(property)  •")
						break
				}
			}
		}
		
		return finalString
	}
	
	/// This function simply updates the menu bar icon with the current one stored in userdefaults
	static func updateIcon() {
		
		let appDelegate = AppDelegate.current()
		let statusItemButton = appDelegate.panelStatusItem?.button
		let icon = appDelegate.interfaceState.settingsMenubarIcon

		statusItemButton?.image = NSImage(named: icon)
		statusItemButton?.image?.isTemplate = true
		
		let icons = ContentManager.MenubarIcons.self
		var size: CGFloat?
		
		// Find the desired size
		switch icon {
			case icons.menubarDefault:
				size = 17.5
				break
			
			case icons.menubarDoc:
				size = 17.25
				break
				
			case icons.menubarDrive:
				size = 17.5
				break
				
			case icons.menubarFolder:
				size = 16.5
				break
				
			case icons.menubarInfo:
				size = 17
				break
				
			case icons.menubarViewfinder:
				size = 16
				break
				
			default:
				break
		}
		
		if let size = size {
			statusItemButton?.image?.size = NSSize(width: size, height: size)
		}
		
		statusItemButton?.updateConstraints()
	}
}

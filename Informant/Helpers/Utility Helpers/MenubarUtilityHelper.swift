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
	
	/// Contains the size of the selection
	static var sizeAsString: String = ""
	
	/// Establishes reference to the status item we want to use
	static let statusItem = AppDelegate.current().panelStatusItem
	
	/// Update utility size
	static func update(force: Bool = false) {
		
		// Grab reference to the appdelegate
		let appDelegate = AppDelegate.current()
		
		/// Gets the state of the selection and if it's a duplicate
		guard let checkedSelection = appDelegate.menubarInterfaceHelper.GetFinderSelection() else {
			wipeMenubarInterface()
			return
		}
		
		// Error selection found
		if checkedSelection.state == .errorSelection {
			return wipeMenubarInterface()
		}
		
		// Duplicate selection found
		else if force == false, checkedSelection.state == .duplicateSelection, let paths = checkedSelection.selection.paths {
			return updateMenubarInterface(newSize: sizeAsString, url: URL(fileURLWithPath: paths[0]))
		}
		
		// Unique selection found
		else {
			/// Path selection
			guard let selection = checkedSelection.selection.paths else {
				return wipeMenubarInterface()
			}
		
			// Make sure selection is only one item. Any more and we wipe the interface
			if selection.count > 1 {
				return wipeMenubarInterface(resetState: true)
			}
		
			// Get URL
			let url = URL(fileURLWithPath: selection[0])
			
			// Initiate check for size if wanted
			if appDelegate.interfaceState.settingsMenubarShowSize == true {
				SelectionHelper.grabSize(url)
			}
			
			// Otherwise still update the menu bar interface
			else {
				updateMenubarInterface(url: url)
			}
		}
	}
	
	/// Updates the status item
	static func updateMenubarInterface(newSize: String? = nil, url: URL) {
		
		// Get a reference to the appdelegate
		let appDelegate = AppDelegate.current()
		
		// Get a reference to settings
		guard let interfaceState = appDelegate.interfaceState else {
			return
		}
		
		// State values
		var isiCloudSyncFile: Bool?
		var isDirectory: Bool?
		var selectionType: CFString?
		
		// Placeholder values to collect details
		var size: String = ""
		var kind: String = ""
		var dimensions: String = ""
		var duration: String = ""
		var codecs: String = ""
		var items: String = ""
		
		// MARK: - Verify & Format Size
		
		// Check to make sure the menu bar utility isn't disabled
		if interfaceState.settingsMenubarUtilityBool == false {
			return
		}

		// Change the size as string if needed
		if let size = newSize {
			sizeAsString = size
		}
		
		// Otherwise empty out the interface
		else {
			sizeAsString = ""
		}
		
		// Confirm that we want to see size
		if interfaceState.settingsMenubarShowSize {
			
			// Filter out unavailable and calculating messages
			if sizeAsString == SelectionHelper.State.Finding.localized {
				size = ContentManager.State.findingNoPeriods
			}
			else if sizeAsString == SelectionHelper.State.Unavailable.localized {
				size = ""
			}
			else {
				size = sizeAsString
			}
		}
		
		// MARK: - Collect Additional URL Resources
		
		let resourceKeys: Set<URLResourceKey> = [
			.localizedTypeDescriptionKey,
			.isUbiquitousItemKey,
			.isDirectoryKey,
			.typeIdentifierKey,
		]
			
		// Get URL resources
		if let resources = SelectionHelper.getURLResources(url, resourceKeys) {
			
			// MARK: Kind
			if let kindUnwrapped = resources.localizedTypeDescription, interfaceState.settingsMenubarShowKind {
				kind = kindUnwrapped
			}
			
			// Needed to get # of items in directory
			isiCloudSyncFile = resources.isUbiquitousItem
			isDirectory = resources.isDirectory
			
			// Find the type of the selection
			let uti = resources.typeIdentifier! as CFString
			
			let types = [
				kUTTypeImage,
				kUTTypeMovie,
			]
			
			for type in types {
				if UTTypeConformsTo(uti, type) {
					selectionType = type
				}
			}
		}
		
		// MARK: Duration & Dimensions & Codecs
		// Collect the duration if it's permitted
		if interfaceState.settingsMenubarShowDuration || interfaceState.settingsMenubarShowDimensions {
			
			let metadataKeys: NSArray = [
				kMDItemDurationSeconds!,
				kMDItemPixelWidth!,
				kMDItemPixelHeight!,
				kMDItemCodecs!,
			]
			
			// Collect data based on type
			switch selectionType {
				
				case kUTTypeImage:
					
					// Get basic metadata
					let metadata = SelectionHelper.getURLImageMetadata(url)
					
					// Get the dimensions
					if interfaceState.settingsMenubarShowDimensions,
					   let dimensionsUnwrapped = SelectionHelper.formatDimensions(x: metadata?[kCGImagePropertyPixelWidth], y: metadata?[kCGImagePropertyPixelHeight])
					{
						dimensions = dimensionsUnwrapped
					}
					
					break
				
				case kUTTypeMovie:
					// Collect dimensions
					if interfaceState.settingsMenubarShowDimensions,
					   let dimensionsUnwrapped = SelectionHelper.getMovieDimensions(url: url)
					{
						dimensions = dimensionsUnwrapped
					}
					
					break
					
				default:
					break
			}
			
			// TODO: clean this up
			// Get URL metadata
			if let metadata = SelectionHelper.getURLMetadata(url, keys: metadataKeys) {
			
				// Collect duration
				if interfaceState.settingsMenubarShowDuration,
				   let durationUnwrapped = SelectionHelper.formatDuration(metadata[kMDItemDurationSeconds])
				{
					duration = durationUnwrapped
				}
					
				// Collect dimensions
				if dimensions.isEmpty,
				   interfaceState.settingsMenubarShowDimensions,
				   let dimensionsUnwrapped = SelectionHelper.formatDimensions(x: metadata[kMDItemPixelWidth], y: metadata[kMDItemPixelHeight])
				{
					dimensions = dimensionsUnwrapped
				}
		
				// Collect Codecs
				if interfaceState.settingsMenubarShowCodecs, let codecUnwrapped = metadata[kMDItemCodecs] as? [String] {
					codecs = codecUnwrapped.joined(separator: ", ")
				}
			}
		}
		
		// MARK: Item Count
		if interfaceState.settingsMenubarShowItems, isiCloudSyncFile != true, isDirectory == true {
			if let itemCount = FileManager.default.shallowCountOfItemsInDirectory(at: url) {
				items = SelectionHelper.formatDirectoryItemCount(itemCount)
			}
		}
		
		// MARK: - Assemble Final View For Util.
		
		// Collect all values
		let properties = [size, items, kind, dimensions, duration, codecs]
		
		// Prepare the formatted string for the view
		let formattedString = formatProperties(properties)
		
		// Get formatted fonts ready
		let font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
		
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
		
		shouldMenubarUtilityAppearDisabled()
		
		statusItem?.button?.attributedTitle = NSAttributedString(string: "")
		
		if resetState == true {
			sizeAsString = ""
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
	static func formatProperties(_ props: [String]) -> String {
		
		var finalString: String = ""
		
		let finalStringSpacing = "  "
		
		// Filter out properties
		let properties = props.filter { $0 != "" }
		
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

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
		
		// Placeholder values to collect details
		var size: String = ""
		var kind: String = ""
		var dimensions: String = ""
		var duration: String = ""
		
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
			
			// Format string prior to use
			size = sizeAsString
		}
		
		// MARK: - Collect Additional URL Resources
		
		// Collect the kind if it's permitted
		if interfaceState.settingsMenubarShowKind {
			
			let resourceKeys: Set<URLResourceKey> = [
				.localizedTypeDescriptionKey,
			]
			
			// Get URL resources
			if let resources = SelectionHelper.getURLResources(url, resourceKeys) {
			
				// Collect kind
				if let kindUnwrapped = resources.localizedTypeDescription {
					kind = kindUnwrapped
				}
			}
		}
		
		// Collect the duration if it's permitted
		if interfaceState.settingsMenubarShowDuration || interfaceState.settingsMenubarShowDimensions {
			
			let metadataKeys: NSArray = [
				kMDItemDurationSeconds!,
				kMDItemPixelWidth!,
				kMDItemPixelHeight!,
			]
			
			// Get URL metadata
			if let metadata = SelectionHelper.getURLMetadata(url, keys: metadataKeys) {
			
				// Collect duration
				if interfaceState.settingsMenubarShowDuration,
				   let durationUnwrapped = SelectionHelper.formatDuration(metadata[kMDItemDurationSeconds])
				{
					duration = durationUnwrapped
				}
					
				// Collect dimensions
				if interfaceState.settingsMenubarShowDimensions,
				   let dimensionsUnwrapped = SelectionHelper.formatDimensions(x: metadata[kMDItemPixelWidth], y: metadata[kMDItemPixelHeight])
				{
					dimensions = dimensionsUnwrapped
				}
			}
		}
		
		// MARK: - Assemble Final View For Util.
		
		// Collect all values
		let properties = [size, kind, dimensions, duration]
		
		// Prepare the formatted string for the view
		let formattedString = formatProperties(properties)
		
		// Get formatted fonts ready
		let font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
		
		// Creates a left justified paragraph style. Makes sure size (102 KB or whatever) stays to the left of the status item
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .left
		
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
}

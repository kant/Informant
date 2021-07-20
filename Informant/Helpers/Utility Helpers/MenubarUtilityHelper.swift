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
	
	/// Update utility size
	static func updateSize() {
		
		/// Gets the state of the selection and if it's a duplicate
		guard let checkedSelection = AppDelegate.current().menubarInterfaceHelper.GetFinderSelection() else {
			wipeMenubarInterface()
			return
		}
		
		// Error selection found
		if checkedSelection.state == .errorSelection {
			return wipeMenubarInterface()
		}
		
		// Duplicate selection found
		else if checkedSelection.state == .duplicateSelection {
			return updateMenubarInterface(size: sizeAsString)
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
			
			// Initiate check for size
			SelectionHelper.grabSize(url)
		}
	}
	
	/// Updates the status item
	static func updateMenubarInterface(size: String? = nil) {
		
		// Check to make sure the menu bar utility isn't disabled
		if AppDelegate.current().interfaceState.settingsMenubarUtilityBool == false {
			return
		}

		// Change the size as string if needed
		if let size = size {
			sizeAsString = size
		}
		
		// Otherwise empty out the interface
		else {
			sizeAsString = ""
		}
		
		// Format string prior to use
		let formattedSize = sizeAsString == "" ? "" : sizeAsString + " "
		
		// Get formatted font ready
		let font = NSFont.systemFont(ofSize: 13, weight: .medium)
		
		// Creates a left justified paragraph style. Makes sure size (102 KB or whatever) stays to the left of the status item
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .left
		
		// Put the attributed string all together
		let attrString = NSAttributedString(string: formattedSize, attributes: [.font: font, .baselineOffset: -0.5, .paragraphStyle: paragraphStyle])
		
		// Update the size
		AppDelegate.current().statusItem.button?.attributedTitle = attrString
	}
	
	/// For when there's no size available
	static func wipeMenubarInterface(resetState: Bool = false) {
		
		AppDelegate.current().statusItem.button?.attributedTitle = NSAttributedString(string: "")
		
		if resetState == true {
			sizeAsString = ""
		}
	}
}

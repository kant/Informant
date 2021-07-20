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
			wipeMenubarInterface()
			return
		}
		
		// Duplicate selection found
		else if checkedSelection.state == .duplicateSelection {
			updateMenubarInterface()
			return
		}
		
		// Unique selection found
		else {
			/// Path selection
			guard let selection = checkedSelection.selection.paths else {
				wipeMenubarInterface()
				return
			}
		
			// Make sure selection is only one item. Any more and we wipe the interface
			if selection.count > 1 {
				wipeMenubarInterface(resetState: true)
				return
			}
		
			// Get URL
			let url = URL(fileURLWithPath: selection[0])
			
			// Initiate check for size
			SelectionHelper.grabSize(url)
		}
	}
	
	/// Updates the status item
	static func updateMenubarInterface(size: String? = nil) {
		
		// Change the size as string if needed
		if let size = size {
			sizeAsString = size + "    "
		}
		
		// Get formatted font ready
		let font = NSFont.systemFont(ofSize: 13, weight: .medium)
		let attrString = NSAttributedString(string: sizeAsString, attributes: [.font: font, .baselineOffset: -0.5])
		
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

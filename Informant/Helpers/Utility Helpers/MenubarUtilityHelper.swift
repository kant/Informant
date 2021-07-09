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
	
	/// Update utility size
	static func updateSize(_ statusItem: NSStatusItem) {
		
		/// Contains formatted size
		var size: String?
		
		/// Gets the state of the selection and if it's a duplicate
		guard let checkedSelection = InterfaceHelper.GetFinderSelection() else {
			wipeMenubarInterface(statusItem)
			return
		}
		
		// Reacts to the state of the selection
		switch checkedSelection.state {
		case .errorSelection: wipeMenubarInterface(statusItem)
			return
			
		case .duplicateSelection:
			return
			
		case .uniqueSelection:
			break
		}
		
		/// Path selection
		guard let selection = checkedSelection.selection.paths else {
			wipeMenubarInterface(statusItem)
			return
		}
		
		// Make sure selection is only one item. Any more and we wipe the interface
		if selection.count > 1 {
			wipeMenubarInterface(statusItem)
			return
		}
		
		// Get URL
		let url = URL(fileURLWithPath: selection[0])
		
		// Keys
		let keys: Set<URLResourceKey> = [
			.totalFileSizeKey,
			.isDirectoryKey
		]
		
		// Get the resources
		if let resources = SelectionHelper.getURLResources(url, keys) {
			
			// End execution if it's a directory
			if resources.isDirectory == true {
				wipeMenubarInterface(statusItem)
				return
			}

			// Get the size
			else if let fileSize = resources.totalFileSize {
				size = SelectionHelper.formatBytes(Int64(fileSize))
			}
		}
		
		// Format size as string
		guard let size = size else {
			wipeMenubarInterface(statusItem)
			return
		}
		
		let sizeAsString = size + "    "
		
		// Get formatted font ready
		let font = NSFont.systemFont(ofSize: 13, weight: .medium)
		let attrString = NSAttributedString(string: sizeAsString, attributes: [.font: font, .baselineOffset: -0.5])
		
		// Update the size
		statusItem.button?.attributedTitle = attrString
	}
	
	/// For when there's no size available
	static func wipeMenubarInterface(_ statusItem: NSStatusItem) {
		statusItem.button?.attributedTitle = NSAttributedString(string: "")
	}
}

//
//  SingleDirectorySelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleDirectorySelection: SingleSelection {
	
	var itemCount: String?
	
	required init(_ urls: [String], selection: SelectionType = .Directory) {
		
		// Get basic selection
		super.init(urls, selection: selection)
		
		// Get access to directory
		if AppDelegate.current().securityBookmarkHelper.startAccessingRootURL() == true, isiCloudSyncFile != true {
			
			// Get directory size
			findDirectorySize()

			// Get # of items in the directory
			if let itemCount = FileManager.default.shallowCountOfItemsInDirectory(at: url) {
				self.itemCount = String(itemCount) + " " + (itemCount > 1 ? ContentManager.Extra.items : ContentManager.Extra.item)
			}
		}
		
		// Otherwise we have no permission to view or it's an iCloud sync file
		else {
			itemSizeAsString = nil
			itemCount = nil
		}
	}
}

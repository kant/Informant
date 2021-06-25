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
		if AppDelegate.current().securityBookmarkHelper.startAccessingRootURL() == true {
			
			// Get # of items in the directory
			if let itemCount = FileManager.default.countOfItemsInDirectory(at: url) {
				self.itemCount = String(itemCount) + " " + (itemCount > 1 ? ContentManager.Extra.items : ContentManager.Extra.item)
			}

			// Tell the user we're calculating the total size
			self.itemSizeAsString = SelectionHelper.State.Calculating
			
			// TODO: This needs to be an async request
			// Get directory size
			do {
				let rawSize = try FileManager.default.allocatedSizeOfDirectory(at: self.url)
				print(SelectionHelper.formatBytes(rawSize))
			} catch { }
		}

		AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
	}
}

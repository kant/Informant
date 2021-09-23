//
//  SingleDirectorySelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleDirectorySelection: SingleSelection {
	
	var itemCount: String?
	
	required init(_ urls: [String], selection: SelectionType = .Directory, parameters: [SelectionParameters] = [.grabSize]) {
		
		// Get basic selection
		super.init(urls, selection: selection, parameters: parameters)
		
		// Get access to directory
		if isiCloudSyncFile != true {
			
			// Get # of items in the directory
			if let itemCount = FileManager.default.shallowCountOfItemsInDirectory(at: url) {
				self.itemCount = SelectionHelper.formatDirectoryItemCount(itemCount)
			}
		}
		
		// Otherwise we have no permission to view or it's an iCloud sync file
		else {
			itemCount = nil
		}
	}
}

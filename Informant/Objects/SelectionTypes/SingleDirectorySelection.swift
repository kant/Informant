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
			
			// Holds raw size in memory
			var rawSize: Int64?
			
			// ------------ Setup work blocks ⤵︎ --------------
			// Executes on the background
			let workBlock1 = DispatchWorkItem {
				
				do {
					rawSize = try FileManager.default.allocatedSizeOfDirectory(at: self.url)
				} catch {
					rawSize = nil
				}
				
				// Stop access on the main thread after completion of this block
				DispatchQueue.main.async(execute: self.workBlocks[1])
			}
			
			// Executes on the main thread
			let workBlock2 = DispatchWorkItem {
				if let size = rawSize {
					self.itemSizeAsString = SelectionHelper.formatBytes(size)
				} else {
					self.itemSizeAsString = SelectionHelper.State.Unavailable
				}
				
				AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
			}
			
			workBlocks.insert(workBlock1, at: 0)
			workBlocks.insert(workBlock2, at: 1)
			
			// Get directory size
			DispatchQueue.global(qos: .userInitiated).async(execute: workBlocks[0])
		}
	}
}

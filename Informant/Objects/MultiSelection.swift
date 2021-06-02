//
//  MultiSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Cocoa
import Foundation

extension Selection {

	/// Fills the data in for intention to be used in a multi-select interface
	func multiSelection(_ urls: [String]) {
		
		// Establish the collection type first
		collectionType = .Multi

		// Start size off at 0
		fileSize = 0
		
		// Establish item count
		let totalCount = urls.count
		
		// Establish title
		title = String(totalCount) + " " + ContentManager.Labels.multiSelectTitle
		
		/// Gather the icons from the first two or three files and use those layered on top of eachother!
		for (index, url) in urls.enumerated() {
			
			let icon = NSWorkspace.shared.icon(forFile: url)
			guard let iconResized = icon.resized(to: ContentManager.Icons.panelHeaderIconSize) else { return }
			totalIcons.append(iconResized)
		
			// Escape loop at desired iteration
			if index >= 6 {
				break
			}
		}
		
		// Establish total size
		for url in urls {
			guard let fileAttributes = getFileAttributes(path: url) else { return }
			fileSize! += (fileAttributes[FileAttributeKey.size] as! Int64)
		}
		
		// Format total size
		fileSizeAsString = ContentManager.Labels.multiSelectSize + " " + ByteCountFormatter().string(fromByteCount: fileSize!)
	}
}

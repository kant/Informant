//
//  MultiSelectedItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Cocoa
import Foundation
import QuickLookThumbnailing

/// Takes a multi item selection and combines all the information together for the interface
class MultiSelectItem: SelectItem, SelectItemProtocol {
	
	required init(urls: [String]) {
		
		super.init()
		
		// Start size off at 0
		size = 0
		
		// Establish item count
		let totalCount = urls.count
		
		// Establish title
		title = String(totalCount) + " " + ContentManager.Labels.multiSelectTitle
		
		/// Gather the icons from the first two or three files and use those layered on top of eachother!
		for (index, url) in urls.enumerated() {
			
			var icon = NSWorkspace.shared.icon(forFile: url)
			icon = icon.resized(to: ContentManager.Icons.panelHeaderIconSize)!
			totalIcons.append(icon)
		
			// Escape loop at desired iteration
			if index >= 6 {
				break
			}
		}
		
		// Establish total size
		for url in urls {
			let fileAttributes = getFileAttributes(path: url)!
			size! += (fileAttributes[FileAttributeKey.size] as? Int64)!
		}
		
		// Format total size
		sizeAsString = ContentManager.Labels.multiSelectSize + " " + ByteCountFormatter().string(fromByteCount: size!)
	}
}

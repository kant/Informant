//
//  MultiSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Cocoa
import Foundation

class MultiSelection: SelectionHelper, SelectionProtocol {
	
	var selectionType: SelectionType = .Multi
	var itemResources: URLResourceValues?
	
	// Metadata ⤵︎
	var itemTitle: String?
	var itemSize: Int?
	var itemSizeAsString: String?
	var itemTotalIcons: [NSImage] = []
	
	/// Fills the data in for intention to be used in a multi-select interface
	required init(_ urls: [String]) {
		
		super.init()
		
		// MARK: - Establish Title
		// Establish item count
		let totalCount = urls.count
		
		// Establish title
		itemTitle = String(totalCount) + " " + ContentManager.Labels.multiSelectTitle
		
		// MARK: - Establish Icon Collection
		/// Gather the icons from the first two or three files and use those layered on top of eachother!
		for (index, url) in urls.enumerated() {
			
			let icon = NSWorkspace.shared.icon(forFile: url)
			guard let iconResized = icon.resized(to: ContentManager.Icons.panelHeaderIconSize) else { return }
			itemTotalIcons.append(iconResized)
		
			// Escape loop at desired iteration
			if index >= 6 {
				break
			}
		}
		
		// MARK: - Establish Total Size
		let keys: Set<URLResourceKey> = [
			.fileSizeKey
		]
		
		// Start size off at 0
		itemSize = 0
		
		// Adds sizes together
		for url in urls {
			guard let resources = getURLResources(URL(fileURLWithPath: url), keys) else { return }
			itemSize! += resources.fileSize!
		}
		
		// Format total size
		itemSizeAsString = ContentManager.Labels.multiSelectSize + " " + ByteCountFormatter().string(fromByteCount: Int64(itemSize!))
	}
}

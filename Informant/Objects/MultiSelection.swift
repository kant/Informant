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

		// MARK: - Establish Title
		// Establish item count
		let totalCount = urls.count
		
		// Establish title
		title = String(totalCount) + " " + ContentManager.Labels.multiSelectTitle
		
		// MARK: - Establish Icon Collection
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
		
		// MARK: - Establish Total Size
		let keys: Set<URLResourceKey> = [
			.fileSizeKey
		]
		
		// Start size off at 0
		size = 0
		
		// Adds sizes together
		for url in urls {
			guard let resources = getURLResources(URL(fileURLWithPath: url), keys) else { return }
			size! += resources.fileSize!
		}
		
		// Format total size
		fileSizeAsString = ContentManager.Labels.multiSelectSize + " " + ByteCountFormatter().string(fromByteCount: Int64(size!))
	}
}

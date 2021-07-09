//
//  SingleVolumeSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-25.
//

import Foundation

class SingleVolumeSelection: SingleSelection {

	var totalCapacity: String?
	var availableCapacity: String?
	var purgeableCapacity: String?

	required init(_ urls: [String], selection: SelectionType = .Volume) {

		// Get basic selection
		super.init(urls, selection: selection)

		// Get permission to view
		if AppDelegate.current().securityBookmarkHelper.startAccessingRootURL() == true {

			let keys: Set<URLResourceKey> = [
				.volumeTotalCapacityKey,
				.volumeAvailableCapacityKey,
				.volumeAvailableCapacityForImportantUsageKey
			]

			// Total size
			if let resources = SelectionHelper.getURLResources(url, keys) {

				/// This is the capacity that the user sees in their storage in settings
				var importantUsageCapacity: Int64?

				// Capacity for important usage
				if let importantCapacity = resources.volumeAvailableCapacityForImportantUsage {
					importantUsageCapacity = importantCapacity
				}

				// Total capacity
				guard let totalCapacity = resources.volumeTotalCapacity else {
					return
				}

				// Available capacity
				guard let availableCapacity = resources.volumeAvailableCapacity else {
					return
				}

				self.totalCapacity = SelectionHelper.formatBytes(Int64(totalCapacity))

				// Displays important capacity only if available
				if let importantCapacity = importantUsageCapacity, importantCapacity != 0 {

					// Calculate purgeable
					let purged = abs(importantCapacity - Int64(availableCapacity))

					self.purgeableCapacity = SelectionHelper.formatBytes(purged)
					self.availableCapacity = SelectionHelper.formatBytes(Int64(importantCapacity))
				}

				// Otherwise use the available capacity
				else {
					self.availableCapacity = SelectionHelper.formatBytes(Int64(availableCapacity))
				}

				// Nil out size so it doesn't appear
				self.itemSizeAsString = nil
			}
		}
	}
}

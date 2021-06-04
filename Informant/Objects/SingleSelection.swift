//
//  SingleSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-01.
//

import Cocoa
import Foundation

extension Selection {

	/// Establishes a single selection foundation and then picks out a type
	func singleSelection(_ urls: [String]) {

		// Set collection type
		collectionType = .Single

		// Provide selection url
		url = URL(fileURLWithPath: urls[0])

		// MARK: - Get Selection Resources

		/// Keys used to determine what resources to grab
		let keys: Set<URLResourceKey> = [
			.canonicalPathKey,
			.nameKey,
			.effectiveIconKey,

			.fileSizeKey,
			.localizedTypeDescriptionKey,

			.creationDateKey,
			.contentModificationDateKey,

			.isUbiquitousItemKey,
			.isHiddenKey,
			.isApplicationKey,
			.tagNamesKey,
			.ubiquitousItemContainerDisplayNameKey
		]

		// Assigning resources to fileResources object
		fileResources = getURLResources(url, keys)

		// MARK: - Fill in fields
		if let resources = fileResources {
			path = resources.canonicalPath
			title = resources.name

			fileIcon = (resources.effectiveIcon! as? NSImage)?.resized(to: ContentManager.Icons.panelHeaderIconSize)
			fileKind = resources.localizedTypeDescription
			fileSize = resources.fileSize
			fileSizeAsString = ByteCountFormatter().string(fromByteCount: Int64(resources.fileSize!))

			fileDateCreated = resources.creationDate
			fileDateModified = resources.contentModificationDate

			// Format dates as strings
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .short
			dateFormatter.doesRelativeDateFormatting = true

			fileDateCreatedAsString = dateFormatter.string(from: fileDateCreated!)
			fileDateModifiedAsString = ContentManager.Labels.panelModified + " " + dateFormatter.string(from: fileDateModified!)

			// Fill in remaining flags
			isiCloudSyncFile = resources.isUbiquitousItem
			isHidden = resources.isHidden
			isApplication = resources.isApplication
			tagNames = resources.tagNames
			iCloudContainerName = resources.ubiquitousItemContainerDisplayName
		}

		// MARK: - See if the file is an iCloud Sync file
		// Grab the extension and unique type identifier
		fileExtension = url.pathExtension

		// If the path extension is .icloud then we want to delete it and ignore it
		if fileExtension == "icloud" {
			let urlWithoutICloudExtension = url.deletingPathExtension()
			fileExtension = urlWithoutICloudExtension.pathExtension
			isiCloudSyncFile = true
		}

		// Determine if the file is hidden or not. Or if it's simply a hidden iCloud file.
		// i.e. determine whether or not the period on the front of the file should be removed
		if isHidden == true && isiCloudSyncFile == true {
			title?.removeFirst()
			isHidden = false
		}
	}
}

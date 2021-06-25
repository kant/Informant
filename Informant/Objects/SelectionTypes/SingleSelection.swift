//
//  SingleSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-01.
//

import Cocoa
import Foundation

class SingleSelection: SelectionHelper, SelectionProtocol, ObservableObject {

	var selectionType: SelectionType
	var itemResources: URLResourceValues?

	// MARK: - Single Selection Fields
	var url: URL!
	var itemPath: String?
	var itemTitle: String?
	var itemIcon: NSImage?

	var itemKind: String?
	var itemSize: Int?
	@Published var itemSizeAsString: String?

	var itemDateCreated: Date?
	var itemDateModified: Date?
	var itemDateCreatedAsString: String?
	var itemDateModifiedAsString: String?

	var itemExtension: String!

	// MARK: - Async work block
	var workQueue: [DispatchWorkItem] = []

	// MARK: - File Tags
	/// Determines if the file has the .icloud extension
	var isiCloudSyncFile: Bool?

	/// Determines if the file is marked hidden
	var isHidden: Bool?

	/// Determines if the file is an application or not
	var isApplication: Bool?

	/// The user's Finder tags tacked on to the file
	var tagNames: [String]?

	/// The iCloud container where this document is actully stored
	var iCloudContainerName: String?

	/// Establishes a single selection foundation and then picks out a type
	required init(_ urls: [String], selection: SelectionType = .Single) {

		selectionType = selection

		super.init()

		// Provide selection url
		url = URL(fileURLWithPath: urls[0])

		// MARK: - Get Selection Resources
		/// Keys used to determine what resources to grab
		let keys: Set<URLResourceKey> = [
			.canonicalPathKey,
			.localizedNameKey,
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
		itemResources = SelectionHelper.getURLResources(url, keys)

		// MARK: - Fill in fields
		if let resources = itemResources {
			itemPath = resources.canonicalPath
			itemTitle = resources.localizedName

			// Check icon for nil before unwrapping
			if let icon = resources.effectiveIcon {
				itemIcon = (icon as? NSImage)?.resized(to: ContentManager.Icons.panelHeaderIconSize)
			}

			itemKind = resources.localizedTypeDescription

			// Check filesize for being nil before unwrapping
			if let size = resources.fileSize {
				itemSize = size
				itemSizeAsString = SelectionHelper.formatBytes(Int64(size))
			} else {
				itemSizeAsString = SelectionHelper.State.Unavailable
			}

			// Format dates as strings
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .medium
			dateFormatter.timeStyle = .short
			dateFormatter.doesRelativeDateFormatting = true

			// Make sure created date is non-nil
			if let createdDate = resources.creationDate {
				itemDateCreated = createdDate
				itemDateCreatedAsString = dateFormatter.string(from: createdDate)
			}

			// Make sure modified date is non-nil
			if let modifiedDate = resources.contentModificationDate {
				itemDateModified = modifiedDate
				itemDateModifiedAsString = ContentManager.Labels.panelModified + " " + dateFormatter.string(from: modifiedDate)
			}

			// Fill in remaining flags
			isiCloudSyncFile = resources.isUbiquitousItem
			isHidden = resources.isHidden
			isApplication = resources.isApplication
			tagNames = resources.tagNames
			iCloudContainerName = resources.ubiquitousItemContainerDisplayName
		}

		// TODO: This snippet currently downloads the file in question when the .icloud and . prefix are removed with the .withoutChanges option in play.
		/*
		 let newURL = URL(fileURLWithPath: "/Users/tyirvine/Library/Mobile Documents/com~apple~CloudDocs/Storage/Downloads/sanmeet-chahil-yv1GhUC1Cvo-unsplash.jpg")
		 var error: NSError?
		 let coordinator = NSFileCoordinator(filePresenter: nil)
		 coordinator.coordinate(readingItemAt: newURL, options: .withoutChanges, error: &error) { URL in
		 	do {
		 		let resources = try URL.promisedItemResourceValues(forKeys: [.fileSizeKey])
		 		let sizeformatted = ByteCountFormatter().string(fromByteCount: Int64(resources.fileSize!))
		 		print(sizeformatted)
		 	} catch {}
		 }
		 */

		// MARK: - See if the file is an iCloud Sync file
		// Grab the extension and unique type identifier
		itemExtension = url.pathExtension

		// If the path extension is .icloud then we want to delete it and ignore it
		if itemExtension == "icloud" {
			let urlWithoutICloudExtension = url.deletingPathExtension()
			itemExtension = urlWithoutICloudExtension.pathExtension
			isiCloudSyncFile = true
		}

		// Determine if the file is hidden or not. Or if it's simply a hidden iCloud file.
		// i.e. determine whether or not the period on the front of the file should be removed
		if isHidden == true && isiCloudSyncFile == true {
			itemTitle?.removeFirst()
			isHidden = false
		}

		// MARK: - Modify File Path
		itemPath = tildeAbbreviatedPath(itemPath)
	}

	/// Modifies the root directory of the path to a ~
	func tildeAbbreviatedPath(_ path: String?) -> String? {
		guard let homeDirectory = FileManager.default.getRealHomeDirectory else {
			return nil
		}

		guard let shortenedPath = path?.replacingOccurrences(of: homeDirectory, with: "~") else {
			return nil
		}

		return shortenedPath
	}

	/// Attempts to find the directory's size on a background thread, then commits changes found on the main thread
	func findDirectorySize() {

		let type = selectionType

		// Check if the url has a stored byte size in the cache
		if let cachedSize = url.getCachedByteSize(type) {
			itemSizeAsString = SelectionHelper.formatBytes(cachedSize)
			return
		}

		// Tell the user we're calculating the total size
		itemSizeAsString = SelectionHelper.State.Calculating

		// Holds raw size in memory
		var rawSize: Int64?

		// ------------ Setup work blocks ⤵︎ --------------
		// Executes on the background
		workQueue.append(DispatchWorkItem {

			do {
				rawSize = try FileManager.default.allocatedSizeOfDirectory(at: self.url)
			} catch {
				rawSize = nil
			}

			// Stop access on the main thread after completion of this block
			DispatchQueue.main.async(execute: self.workQueue[1])
		})

		// Executes on the main thread
		workQueue.append(DispatchWorkItem {

			if let size = rawSize {
				self.itemSizeAsString = SelectionHelper.formatBytes(size)
				self.url.storeByteSize(size, type)
			} else {
				self.itemSizeAsString = SelectionHelper.State.Unavailable
			}

			AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
		})

		// Get directory size
		DispatchQueue.global(qos: .utility).async(execute: workQueue[0])
	}
}

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

	// MARK: - Async work block
	var workQueue: [DispatchWorkItem] = []

	// MARK: - File Tags
	/// Determines if the file has the .icloud extension
	var isiCloudSyncFile: Bool?

	/// Determines if the file is marked hidden
	var isHidden: Bool?

	/// Determines if the file is an application or not
	var isApplication: Bool?

	/// Determines if the file is downloaded or not
	var isDownloaded: Bool?

	/// The user's Finder tags tacked on to the file
	var selectionTags: SelectionTags?

	/// The iCloud container where this document is actully stored
	var iCloudContainerName: String?

	/// Placeholder for delegate
	let appDelegate: AppDelegate

	/// Establishes a single selection foundation and then picks out a type
	required init(_ urls: [String], selection: SelectionType = .Single) {

		appDelegate = AppDelegate.current()

		selectionType = selection

		super.init()

		// Provide selection url
		url = URL(fileURLWithPath: urls[0])

		// MARK: - Get Selection Resources
		/// Keys used to determine what resources to grab
		let keys: Set<URLResourceKey> = [
			.localizedNameKey,
			.effectiveIconKey,

			.totalFileSizeKey,
			.localizedTypeDescriptionKey,

			.creationDateKey,
			.contentModificationDateKey,

			.isUbiquitousItemKey,
			.isHiddenKey,
			.isApplicationKey,
			.tagNamesKey,
			.ubiquitousItemContainerDisplayNameKey
		]

		// Start accessing security scoped resource
		if appDelegate.securityBookmarkHelper.startAccessingRootURL() == true {

			// Assigning resources to fileResources object
			itemResources = SelectionHelper.getURLResources(url, keys)

			// MARK: - Fill in fields
			if let resources = itemResources {

				itemTitle = resources.localizedName

				// Check icon for nil before unwrapping
				if let icon = resources.effectiveIcon {
					itemIcon = (icon as? NSImage)?.resized(to: ContentManager.Icons.panelHeaderIconSize)
				}

				itemKind = resources.localizedTypeDescription

				// Check filesize for being nil before unwrapping
				if let size = resources.totalFileSize {
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

				// Get Finder tags
				do {
					let resources = try url.resourceValues(forKeys: [.tagNamesKey])
					if let tags = resources.tagNames {
						selectionTags = SelectionTags(tags: tags)
					}
				} catch { }

				// Fill in remaining flags
				isiCloudSyncFile = resources.isUbiquitousItem
				isHidden = resources.isHidden
				isApplication = resources.isApplication
				iCloudContainerName = resources.ubiquitousItemContainerDisplayName
				isDownloaded = checkIfDownloaded()
			}
		}

		// Stop accessing the resource
		appDelegate.securityBookmarkHelper.stopAccessingRootURL()

		// MARK: - Modify Size
		if isDownloaded == false {
			itemSizeAsString = nil
		}

		// Backup item path
		itemPath = url.path
	}

	/// Check if the file is downloaded
	func checkIfDownloaded() -> Bool {
		if url.pathExtension != "icloud" {
			return true
		} else {
			return false
		}
	}

	/// Checks the url and settings and decides if the full url should be shown
	func isPathFullLength(_ interfaceState: InterfaceState) -> Bool {

		// Check if the user wants to see where the file is located or the full path length
		if interfaceState.settingsPanelShowFullPath == false {
			var whereURL = url
			whereURL?.deleteLastPathComponent()
			itemPath = tildeAbbreviatedPath(whereURL?.path)
			return false
		}

		// Otherwise show the full path
		else {
			itemPath = tildeAbbreviatedPath(url.path)
			return true
		}
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
				self.url.storeByteSize(size, type: type)
			} else {
				self.itemSizeAsString = SelectionHelper.State.Unavailable
			}

			AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
		})

		// Get directory size
		DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.1, execute: workQueue[0])
	}
}

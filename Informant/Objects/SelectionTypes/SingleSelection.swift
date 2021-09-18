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
	@Published var itemSizeAsString: String?

	var itemDateCreated: Date?
	var itemDateModified: Date?
	var itemDateCreatedAsString: String?
	var itemDateModifiedAsString: String?

	// MARK: - File Tags
	/// Determines if the file has the .icloud extension
	var isiCloudSyncFile: Bool?

	/// Determines if the file is marked hidden
	var isHidden: Bool?

	/// Determines if the file is an application or not
	var isApplication: Bool?

	/// The user's Finder tags tacked on to the file
	var selectionTags: SelectionTags?

	/// The iCloud container where this document is actully stored
	var iCloudContainerName: String?

	/// Placeholder for delegate
	let appDelegate: AppDelegate

	/// Establishes a single selection foundation and then picks out a type
	required init(_ urls: [String], selection: SelectionType = .Single, parameters: [SelectionParameters] = [.grabSize]) {

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

		do {
			let resources = try url.resourceValues(forKeys: [.tagNamesKey, .localizedTypeDescriptionKey])
			if let tags = resources.tagNames, let kind = resources.localizedTypeDescription {
				selectionTags = SelectionTags(tags: tags)
				itemKind = kind
			}
		} catch { }

		// Assigning resources to fileResources object
		itemResources = SelectionHelper.getURLResources(url, keys)

		// Grab size
		if parameters.contains(.grabSize) {
			SelectionHelper.grabSize(url, panelSelection: self)
		}

		// MARK: - Fill in fields
		if let resources = itemResources {

			itemTitle = resources.localizedName

			// Check icon for nil before unwrapping
			if let icon = resources.effectiveIcon {
				itemIcon = (icon as? NSImage)?.resized(to: ContentManager.Icons.panelHeaderIconSize)
			}

			// Get the kind description if no description was already found
			if itemKind == nil {
				itemKind = resources.localizedTypeDescription
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
			iCloudContainerName = resources.ubiquitousItemContainerDisplayName
		}

		// Backup item path
		itemPath = url.path
	}

	/// Checks the url and settings and decides if the full url should be shown
	func isPathFullLength(_ interfaceState: InterfaceState) -> Bool {

		// Check if the user wants to see where the file is located or the full path length
		if interfaceState.settingsPanelDisplayFullPath == false {
			var whereURL = url
			whereURL?.deleteLastPathComponent()
			itemPath = SelectionHelper.formatPathTildeAbbreviate(whereURL?.path)
			return false
		}

		// Otherwise show the full path
		else {
			itemPath = SelectionHelper.formatPathTildeAbbreviate(url.path)
			return true
		}
	}
}

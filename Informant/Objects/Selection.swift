//
//  FileObject.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Cocoa
import Foundation

class Selection: SelectionProtocol {

	/// Defines the selection type used. Must not be nil!
	var collectionType: CollectionType?

	public enum CollectionType {
		case Single
		case Multi
		case Directory
	}

	/// Contains all resources for the file
	var fileResources: URLResourceValues?

	// All file metadata ⤵︎
	var url: URL!
	var path: String?
	var title: String?
	var fileIcon: NSImage?
	var totalIcons: [NSImage] = []

	var fileKind: String?
	var size: Int?
	var fileSizeAsString: String?

	var fileDateCreated: Date?
	var fileDateModified: Date?
	var fileDateCreatedAsString: String?
	var fileDateModifiedAsString: String?

	var fileExtension: String!

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

	// MARK: - Methods
	// This function will take in a url string and provide a url resource values object which can be
	// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	func getURLResources(_ url: URL, _ keys: Set<URLResourceKey>) -> URLResourceValues? {
		do {
			return try url.resourceValues(forKeys: keys)
		}
		catch {
			return nil
		}
	}

	// ------------- Initialization ⤵︎ ----------------

	required init?(_ urls: [String]) {

		// MARK: - Determine if the selection is multi or single

		// A multiselectitem if multiple items are selected
		if urls.count >= 2 {
			multiSelection(urls)
		}

		// Use some single selection init if only one item is selected
		else if urls.count == 1 {
			singleSelection(urls)
		}

		// Otherwise just link the reference to nil
		else {
			return nil
		}
	}
}

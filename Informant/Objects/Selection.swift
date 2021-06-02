//
//  FileObject.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Cocoa
import Foundation

class Selection {

	var fileResources: URLResourceValues?

	var url: URL?
	var path: String?
	var title: String?
	var typeIcon: NSImage?
	var totalIcons: [NSImage] = []

	var fileType: String?
	var fileKind: String?

	var fileSize: Int64?
	var fileSizeAsString: String?

	var fileDateCreated: Date?
	var fileDateModified: Date?
	var fileDateCreatedAsString: String?
	var fileDateModifiedAsString: String?

	public enum CollectionType {
		case Single
		case Multi
		case Directory
	}

	var collectionType: CollectionType?

	/// This is the actually path extension - PNG, ICO, etc.
	var fileExtension: String!

	// MARK: - File Tags
	/// Determines if the file has the .icloud extension
	var isICloudSyncFile: Bool?

	/// Determines if the file is marked hidden
	var isHidden: Bool?

	/// Determines if the file is an application or not
	var isApplication: Bool?

	// MARK: - Methods
	// This function will take in a url string and provide a file attribute object which can be
	// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	func getFileAttributes(path: String) -> [FileAttributeKey: Any]? {
		do {
			return try FileManager.default.attributesOfItem(atPath: path)
		}
		catch {
			return nil
		}
	}

	// ------------- Initialization ⤵︎ ----------------

	init?(_ urls: [String]) {

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

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

		collectionType = .Single

		// MARK: - Fill in all fields with the selected item's properties
		url = URL(fileURLWithPath: urls[0])
		path = urls[0]

		// Grabs file name using last part of path
		if path!.last == "/" {
			let directoryPath = String(path!.dropLast())
			title = URL(fileURLWithPath: directoryPath).lastPathComponent
		}

		// Check to see if the file is hidden first
		// https://stackoverflow.com/a/34745124/13142325
		else {
			title = url!.lastPathComponent
		}

		// Grabs the file's attributes
		guard let fileAttributes = getFileAttributes(path: path!) else {
			return
		}

		// Grab icon and resize it
		typeIcon = NSWorkspace.shared.icon(forFile: path!)
		typeIcon = typeIcon?.resized(to: ContentManager.Icons.panelHeaderIconSize)

		// Inject attributes into the object
		fileDateCreated = fileAttributes[FileAttributeKey.creationDate] as? Date
		fileDateModified = fileAttributes[FileAttributeKey.modificationDate] as? Date
		fileSize = fileAttributes[FileAttributeKey.size] as? Int64

		// Format bytes
		let byteFormatter = ByteCountFormatter()
		fileSizeAsString = byteFormatter.string(fromByteCount: fileSize!)

		// Format dates
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.doesRelativeDateFormatting = true

		fileDateCreatedAsString = dateFormatter.string(from: fileDateCreated!)
		fileDateModifiedAsString = ContentManager.Labels.panelModified + " " + dateFormatter.string(from: fileDateModified!)

		// MARK: - See if the file is an iCloud sync file
		// Grab the extension and unique type identifier
		fileExtension = url!.pathExtension

		// If the path extension is .icloud then we want to delete it and ignore it
		if fileExtension == "icloud" {
			let urlWithoutICloudExtension = url?.deletingPathExtension()
			fileExtension = urlWithoutICloudExtension!.pathExtension
			isICloudSyncFile = true
		}

		// MARK: - Get Selection Resources
		// Determine if the file is hidden or not. Or if it's simply a hidden iCloud file

		let keys: Set<URLResourceKey> = [
			.isHiddenKey,
			.isApplicationKey,
			.localizedTypeDescriptionKey,
			.fileSizeKey,
		]

		do {
			guard let resources = try url?.resourceValues(forKeys: keys) else { return }
			fileResources = resources
		}
		catch {}

		// Fill in flags
		isHidden = fileResources?.isHidden
		isApplication = fileResources?.isApplication
		fileKind = fileResources?.localizedTypeDescription

		// Determine whether or not the period on the front of the file should be removed
		if isHidden == true && isICloudSyncFile == true {
			title?.removeFirst()
			isHidden = false
		}
	}
}

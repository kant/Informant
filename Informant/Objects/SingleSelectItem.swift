//
//  SingleSelectItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-24.
//

import Cocoa
import Foundation

class SingleSelectItem: SelectItem, SelectItemProtocol {

	// MARK: - Initialize Single Item Object
	// This init grabs all relevant information for the file
	required init(url: String) {

		super.init()

		// MARK: - Fill in all fields with the selected item's properties
		fileURL = URL(fileURLWithPath: url)
		filePath = url

		// Grabs the file's attributes
		guard let fileAttributes = getFileAttributes(path: filePath!) else {
			return
		}

		// Grabs file name using last part of path
		if filePath!.last == "/" {
			let directoryPath = String(filePath!.dropLast())
			fileName = URL(fileURLWithPath: directoryPath).lastPathComponent
		}
		else {
			fileName = URL(fileURLWithPath: filePath!).lastPathComponent
		}

		// Inject attributes into the object
		fileTypeIcon = NSWorkspace.shared.icon(forFile: filePath!)
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
		fileDateModifiedAsString = dateFormatter.string(from: fileDateModified!)

		// Find the item type (folder / file)
		fileType = fileAttributes[FileAttributeKey.type] as? String

		// MARK: - Item Kind Selection
		// Check if the selected item is a directory or a file - Is a directory
		if fileType! == "NSFileTypeDirectory" {
			fileKind = "Folder"
		}

		// Is not a directory
		else {
			// This is like if the item is an image, application etc.
			var itemType: String?

			// This is the actually path extension - PNG, ICO, etc.
			var itemExtension: String

			// Grab the extension and unique type identifier
			itemExtension = NSURL(fileURLWithPath: filePath!).pathExtension!
			let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension as CFString, itemExtension as CFString, nil)?.takeRetainedValue()

			// Determines if the uti conforms
			func doesConform(kUTType: CFString) -> Bool {
				return UTTypeConformsTo(uti!, kUTType)
			}

			// Gets the item's UTI description
			func getUTIDescription() -> String? {
				if UTTypeCopyDescription(uti!)?.takeRetainedValue() != nil {
					return UTTypeCopyDescription(uti!)!.takeRetainedValue() as String
				}
				else {
					return nil
				}
			}

			// Turn item into a document item
			func appendDocument(item: String) -> String {
				var file: String = item
				if file.numberOfWords > 1 {
					file = file.components(separatedBy: " ").dropLast().joined(separator: " ")
					file += " document"
					return file
				}
				else {
					return file
				}
			}

			// Make a directory of all types to check
			let types: [CFString: String] = [
				// Media types
				kUTTypeImage: "image",
				kUTTypeVideo: "video",
				kUTTypeAudio: "audio"
			]

			// Check if it's definable item, such as a video etc. We do this because we want to find items
			// that use the type and extension in their kind description. Otherwise we're gonna use the
			// regular UTType description, it's actually pretty good.
			for type in types {
				if doesConform(kUTType: type.key) {

					itemType = type.value
					break
				}
			}

			// Now check if an item type was found. If a type was found then assign fileKind. If no type was
			// found then find the type and don't write the extension.
			if itemType != nil {
				fileKind = itemExtension.uppercased() + " " + itemType!.capitalized
			}

			// Unfortunately the library for these descriptions isn't very good so we have to make some exceptions
			// to them ourself
			else {

				// Check if you can even extract a UTType from the file
				if let utiDescription: String = getUTIDescription() {

					// Typically the description is just Javascript
					if doesConform(kUTType: kUTTypeJavaScript) {
						itemType = "javascript source"
					}

					// All source code files
					else if doesConform(kUTType: kUTTypeSourceCode) {
						itemType = utiDescription
					}

					// Edit text documents - Decide
					else if doesConform(kUTType: kUTTypeText) {
						itemType = appendDocument(item: utiDescription)
					}

					// Non-exceptions
					else {
						itemType = utiDescription
					}
				}

				//	If you can't extract a UTType then just label it a document
				else {
					itemType = "document"
				}

				// MARK: - Relabel File Extension Kind Label
				// These are just additional file extension specific overrides!
				switch itemExtension {
				default:
					break
				}

				// Capitalize items without lowercasing already uppercased words
				fileKind = itemType!.capitalizeEachWord
			}
		}
	}
}

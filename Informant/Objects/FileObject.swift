//
//  FileObject.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Cocoa
import Foundation

class FileObject {
	private var fileURL: URL
	public var filePath: String?
	public var fileName: String?
	public var fileTypeIcon: NSImage?

	public var fileKind: String?

	private var fileSize: Int64?
	public var fileSizeAsString: String?

	private var fileDateCreated: Date?
	private var fileDateModified: Date?
	public var fileDateCreatedAsString: String?
	public var fileDateModifiedAsString: String?

	// This init grabs all relevant information for the file
	init(url: String) {
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

		// Check if the selected item is a directory or a file - Is a directory
		if fileURL.pathExtension == "" {
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
			let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension as CFString, itemExtension as CFString, nil)?.takeUnretainedValue()

			// Determines if the uti conforms
			func doesConform(kUTType: CFString) -> Bool {
				return UTTypeConformsTo(uti!, kUTType)
			}

			// Gets the item's UTI description
			func getUTIDescription() -> String {
				return UTTypeCopyDescription(uti!)!.takeRetainedValue() as String
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
				// Exceptions
				if doesConform(kUTType: kUTTypeJavaScript) {
					itemType = "javascript source"
				}

				// All source code files
				else if doesConform(kUTType: kUTTypeSourceCode) {
					itemType = getUTIDescription()
				}

				// Edit text documents
				else if doesConform(kUTType: kUTTypeText) {
					var utiDescription: String = getUTIDescription()
					utiDescription = appendDocument(item: utiDescription)
					itemType = utiDescription
				}

				// Non-exceptions
				else {
					itemType = getUTIDescription()
				}

				// Capitalize items without lowercasing already uppercased words
				fileKind = itemType!.capitalizeEachWord
			}

//			let uttype = UTTypeCreatePreferredIdentifierForTag(uti!.takeRetainedValue(), kUTTagClassFilenameExtension)!.takeRetainedValue()
//			itemType = UTTypeCopyDescription(uti!.takeRetainedValue())!.takeRetainedValue() as String

//			 Find super type. We attach this to the path extension
//			if doesConform(kUTType: kUTTypeImage) {
//				itemType = "image"
//			} else if doesConform(kUTType: kUTTypeVideo) {
//				itemType = "video"
//			} else if doesConform(kUTType: kUTTypeAudio) {
//				itemType = "audio"
//			} else if doesConform(kUTType: kUTTypeDiskImage) {
//				itemType = "disk"
//			} else if doesConform(kUTType: kUTTypeApplication) {
//				itemType = UTTypeCopyDescription(kUTTypeApplication)!.takeRetainedValue() as String
//			} else {
//				itemType = "none"
//			}

//			let fileExtension: CFString = NSURL(fileURLWithPath: filePath!).pathExtension! as CFString
//			let unmanagedFileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)?.takeUnretainedValue()
//			let mimeUTI = UTTypeCopyPreferredTagWithClass(unmanagedFileUTI!, kUTTagClassMIMEType)!.takeRetainedValue() as String
//			fileKind = itemType.capitalized
//
			////			fileKind = fileURL.pathExtension.uppercased()
		}
	}

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
}

class FileCollection: ObservableObject {

	public enum CollectionType {
		case Single
		case Multi
		case Directory
	}

	@Published public var files: [FileObject] = []
	@Published public var summary: FileObject?
	public let collectionType: CollectionType?

	init(collectionType: CollectionType, filePaths: [String]) {
		self.collectionType = collectionType

		for path in filePaths {
			files.append(FileObject(url: path))
		}
	}
}

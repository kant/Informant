//
//  FileObject.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Cocoa
import Foundation

class SelectItem {
	public var fileURL: URL?
	public var filePath: String?
	public var fileName: String?
	public var fileTypeIcon: NSImage?

	public var fileType: String?
	public var fileKind: String?

	public var fileSize: Int64?
	public var fileSizeAsString: String?

	public var fileDateCreated: Date?
	public var fileDateModified: Date?
	public var fileDateCreatedAsString: String?
	public var fileDateModifiedAsString: String?

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

protocol SelectItemProtocol {
	init(url: String)
}

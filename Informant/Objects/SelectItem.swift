//
//  FileObject.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-17.
//

import Cocoa
import Foundation

protocol SelectItemProtocol {

	var title: String? { get set }
	var typeIcon: NSImage? { get set }

	var size: Int64? { get set }
	var sizeAsString: String? { get set }

	init(urls: [String])
}

class SelectItem {

	public var url: URL?
	public var path: String?
	public var title: String?
	public var typeIcon: NSImage?
	public var totalIcons: [NSImage] = []

	public var fileType: String?
	public var fileKind: String?

	public var size: Int64?
	public var sizeAsString: String?

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

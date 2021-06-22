//
//  SingleImageSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation
import SwiftUI

class SingleImageSelection: SingleSelection {

	var camera: String?
	var focalLength: String?
	var aperture: String?
	var shutterSpeed: String?
	var iso: String?
	var dimensions: String?
	var colorProfile: String?

	required init(_ urls: [String], selection: SelectionType = .Image) {

		// Initialize basic selection properties
		super.init(urls, selection: selection)

		// Gather additional image data
		if AppDelegate.current().securityBookmarkHelper.startAccessingRootURL() == true {

			// Get basic metadata and exif data
			let nsurl = NSURL(fileURLWithPath: url.path)
			let source = CGImageSourceCreateWithURL(nsurl, nil)!
			let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as Dictionary?

			// Fill in fields based on the metadata and exif data
			if let exifDict = metadata?[kCGImagePropertyExifDictionary] {
			}

			if let tiffDict = metadata?[kCGImagePropertyTIFFDictionary] {
				self.camera = tiffDict[kCGImagePropertyTIFFModel] as? String
			}

//			print(metadata)
		}

		print(camera)

		AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
	}
}

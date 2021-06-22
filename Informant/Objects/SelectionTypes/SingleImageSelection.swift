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

//		print(url.startAccessingSecurityScopedResource())

//		let fileURL = url as CFURL
//		if let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil) {
//			let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
//			if let dict = imageProperties as? [String: Any] {
//				print(dict)
//			}
//		}
//		url.stopAccessingSecurityScopedResource()

		#warning("FIX ME!")
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = true
		panel.canChooseFiles = false
		panel.prompt = "Grant access!!!"
		panel.beginSheetModal(for: AppDelegate.current().window) { response in
			if response == .OK {
				print(panel.url!.path)

				// Gather additional image data
				let nsurl = NSURL(fileURLWithPath: self.url.path)
				let source = CGImageSourceCreateWithURL(nsurl, nil)!
				let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as Dictionary?
				let exifDict = metadata?[kCGImagePropertyExifDictionary]
				let dateTimeOriginal = exifDict?[kCGImagePropertyExifDateTimeOriginal]

				print(dateTimeOriginal)
			}
			panel.close()
		}
	}
}

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
			let metadata = SelectionHelper.getURLImageMetadata(url)

			// MARK: - Fill in fields based on the exif data
			if let exifDict = metadata?[kCGImagePropertyExifDictionary] as? [CFString: Any] {

				if let focalLength = exifDict[kCGImagePropertyExifFocalLength] {
					self.focalLength = String(describing: focalLength) + " mm"
				}

				if let aperture = exifDict[kCGImagePropertyExifFNumber] {
					self.aperture = "f⧸" + String(describing: aperture)
				}

				if let shutter = exifDict[kCGImagePropertyExifExposureTime] {
					let fraction = Rational(approximating: shutter as! Double)
					self.shutterSpeed = String(fraction.numerator.description + "/" + fraction.denominator.description)
				}

				if let iso = (exifDict[kCGImagePropertyExifISOSpeedRatings] as? NSArray) {
					self.iso = String(describing: iso[0])
				}
			}

			// MARK: - Used for other info relating to tiff data
			if let tiffDict = metadata?[kCGImagePropertyTIFFDictionary] as? [CFString: Any] {
				if let camera = tiffDict[kCGImagePropertyTIFFModel] {
					self.camera = String(describing: camera)
				}
			}

			// MARK: - Fill in data using just metadata
			self.colorProfile = metadata?[kCGImagePropertyProfileName] as? String

			// Dimensions
			if let dimensions = SelectionHelper.formatDimensions(x: metadata?[kCGImagePropertyWidth], y: metadata?[kCGImagePropertyHeight]) {
				self.dimensions = dimensions
			}
		}

		/*
		 print(camera)
		 print(focalLength)
		 print(aperture)
		 print(shutterSpeed)
		 print(iso)
		 print(dimensions)
		 print(colorProfile)
		 */

		AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
	}
}

//
//  SingleMovieSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleMovieSelection: SingleSelection {

	var codecs: [String]?
	var duration: String?
	var colorProfile: String?
	var dimensions: String?

	required init(_ urls: [String], selection: SelectionType = .Movie) {

		// Initialize basic selection
		super.init(urls, selection: selection)

		// Gather additional movie data
		if AppDelegate.current().securityBookmarkHelper.startAccessingRootURL() == true {

			// These are the values we want to acccess
			let keys: NSArray = [
				kMDItemCodecs!,
				kMDItemDurationSeconds!,
				kMDItemProfileName!,
				kMDItemPixelWidth!,
				kMDItemPixelHeight!
			]

			// Gather basic metadata for movie
			if let metadata = SelectionHelper.getURLMetadata(url, keys: keys) {

				// Codecs
				if let codecs = metadata[kMDItemCodecs] as? [String] {
					self.codecs = codecs
				}

				// Duration
				if let duration = metadata[kMDItemDurationSeconds] {
					self.duration = SelectionHelper.formatDuration(duration)
				}

				// Color Profile
				if let colorProfile = metadata[kMDItemProfileName] {
					self.colorProfile = String(describing: colorProfile)
				}

				// Dimensions
				if let dimensions = SelectionHelper.formatDimensions(x: metadata[kMDItemPixelWidth], y: metadata[kMDItemPixelHeight]) {
					self.dimensions = dimensions
				}
			}
		}

		AppDelegate.current().securityBookmarkHelper.stopAccessingRootURL()
	}
}

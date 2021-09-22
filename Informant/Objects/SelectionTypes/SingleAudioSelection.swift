//
//  SingleAudioSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import AVFoundation
import Foundation

class SingleAudioSelection: SingleSelection {

	var duration: String?
	var sampleRate: String?
	var audioBitrate: String?

	required init(_ urls: [String], selection: SelectionType = .Audio, parameters: [SelectionParameters] = [.grabSize]) {

		// Intialize the basic selection
		super.init(urls, selection: selection, parameters: parameters)

		// Metadata we want to collect
		let keys: NSArray = [
			kMDItemDurationSeconds!,
			kMDItemAudioSampleRate!,
			kMDItemAudioBitRate!
		]

		// Grab the metadata
		if let metadata = SelectionHelper.getURLMetadata(url, keys: keys) {

			// Duration
			if let duration = metadata[kMDItemDurationSeconds] {
				self.duration = SelectionHelper.formatDuration(duration)
			}

			// Sample rate
			if let sampleRate = metadata[kMDItemAudioSampleRate] {
				self.sampleRate = SelectionHelper.formatSampleRate(sampleRate)
			}

			// Audio bitrate
			if let audioBitrate = metadata[kMDItemAudioBitRate] as? Int64 {
				self.audioBitrate = SelectionHelper.formatBitrate(audioBitrate)
			}
		}
	}
}

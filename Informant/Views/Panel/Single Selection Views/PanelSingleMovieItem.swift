//
//  PanelSingleMovieItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleMovieItem: View {

	var selection: SingleMovieSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleMovieSelection
	}

	var body: some View {
		PanelSingleFrame(selection) {

			// Codecs & Duration
			ComponentsPanelItemStack(firstValue: selection?.codecs, secondValue: selection?.duration) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelCodecs, value: selection?.codecs, lineLimit: nil)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelDuration, value: selection?.duration)
			}

			// Video and audio bitrates
			ComponentsPanelItemStack(firstValue: selection?.videoBitrate, secondValue: selection?.audioBitrate) {
				ComponentsPanelItemField(label: ContentManager.SettingsLabels.menubarShowVideoBitrate, value: selection?.videoBitrate, lineLimit: 2)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.SettingsLabels.menubarShowAudioBitrate, value: selection?.audioBitrate, lineLimit: 2)
			}

			// Dimensions & Color Profile
			ComponentsPanelItemStack(firstValue: selection?.dimensions, secondValue: selection?.colorProfile) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelDimensions, value: selection?.dimensions)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelColorProfile, value: selection?.colorProfile)
			}
		}
	}
}

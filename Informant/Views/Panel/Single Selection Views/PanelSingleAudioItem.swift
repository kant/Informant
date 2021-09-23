//
//  PanelSingleAudioItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleAudioItem: View, PanelProtocol {

	var selection: SingleAudioSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleAudioSelection
	}

	var body: some View {
		PanelSingleFrame(selection) {

			// Samplerate & Duration
			ComponentsPanelItemStack(firstValue: selection?.sampleRate, secondValue: selection?.duration) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelSampleRate, value: selection?.sampleRate)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelDuration, value: selection?.duration)
			}

			// Audio Bitrate
			ComponentsPanelItemField(label: ContentManager.SettingsLabels.bitrate, value: selection?.audioBitrate, lineLimit: 2)
		}
	}
}

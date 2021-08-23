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
				ComponentsPanelItemField(label: ContentManager.Labels.panelCodecs, value: selection?.codecs)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelDuration, value: selection?.duration)
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

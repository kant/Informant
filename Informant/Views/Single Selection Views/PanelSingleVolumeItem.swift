//
//  PanelSingleVolumeItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-25.
//

import SwiftUI

struct PanelSingleVolumeItem: View, PanelProtocol {

	var selection: SingleVolumeSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleVolumeSelection
	}

	var body: some View {
		PanelSingleFrame(selection) {

			// Total & available capacity
			ComponentsPanelItemStack(firstValue: selection?.totalCapacity, secondValue: selection?.availableCapacity) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelTotal, value: selection?.totalCapacity)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelAvailable, value: selection?.availableCapacity)
			}

			// Purgeable
			ComponentsPanelItemField(label: ContentManager.Labels.panelPurgeable, value: selection?.purgeableCapacity)
		}
	}
}

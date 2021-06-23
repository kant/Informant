//
//  PanelSingleImageItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleImageItem: View {

	var selection: SingleImageSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleImageSelection
	}

	var body: some View {
		PanelSingleFrame(selection) {

			// Camera
			ComponentsPanelItemField(label: ContentManager.Labels.panelCamera, value: selection?.camera)

			// Focal Length & Exposure / Shutter Speed
			ComponentsPanelItemStack(firstValue: selection?.focalLength, secondValue: selection?.shutterSpeed) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelFocalLength, value: selection?.focalLength)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelExposure, value: selection?.shutterSpeed)
			}

			// Dimensions & Color Profile
			ComponentsPanelItemStack(firstValue: selection?.dimensions, secondValue: selection?.colorProfile) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelDimensions, value: selection?.dimensions)
			} secondItem: {
				ComponentsPanelItemField(label: ContentManager.Labels.panelColorProfile, value: selection?.colorProfile)
			}

			// ISO & Aperture
			ComponentsPanelItemStack(firstValue: selection?.aperture, secondValue: selection?.iso) {
				ComponentsPanelItemField(label: ContentManager.Labels.panelAperture, value: selection?.aperture)
			} secondItem: {
				ComponentsPanelItemField(label: "ISO", value: selection?.iso)
			}
		}
	}
}

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

			// Camera & Focal Length
			ComponentsPanelItemStack(firstValue: selection?.camera, secondValue: selection?.focalLength) {
				ComponentsPanelItemField(label: "Camera", value: selection?.camera)
			} secondItem: {
				ComponentsPanelItemField(label: "Focal Length", value: selection?.focalLength)
			}

			// Dimensions & Color Profile
			ComponentsPanelItemStack(firstValue: selection?.dimensions, secondValue: selection?.colorProfile) {
				ComponentsPanelItemField(label: "Dimensions", value: selection?.dimensions)
			} secondItem: {
				ComponentsPanelItemField(label: "Color Profile", value: selection?.colorProfile)
			}

			// Aperture & Shutter Speed
			ComponentsPanelItemStack(firstValue: selection?.aperture, secondValue: selection?.shutterSpeed) {
				ComponentsPanelItemField(label: "Aperture", value: selection?.aperture)
			} secondItem: {
				ComponentsPanelItemField(label: "Exposure", value: selection?.shutterSpeed)
			}

			// ISO
			ComponentsPanelItemField(label: "ISO", value: selection?.iso)
		}
	}
}

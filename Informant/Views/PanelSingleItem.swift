//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PanelSingleItem: View, PanelProtocol {

	var selection: SingleSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleSelection
	}

	var body: some View {

		ComponentsPanelFullFrame {

			ComponentsPanelHeader(
				headerTitle: selection?.itemTitle,
				headerIcon: selection?.itemIcon,
				headerSubtitle: selection?.itemDateModifiedAsString
			)
			.padding([.bottom], 7)

			Divider().padding(.bottom, 10)

			VStack(alignment: .leading, spacing: 15) {

				// Kind & Size
				ComponentsPanelItemStack(firstValue: selection!.itemKind, secondValue: selection!.itemSizeAsString) {
					ComponentsPanelItemField(label: ContentManager.Labels.panelKind, value: selection?.itemKind, lineLimit: 2)
				} secondItem: {
					ComponentsPanelItemField(label: ContentManager.Labels.panelSize, value: selection?.itemSizeAsString, lineLimit: 1)
				}

				// Created
				ComponentsPanelItemField(label: ContentManager.Labels.panelCreated, value: selection?.itemDateCreatedAsString)

				// Path
				ComponentsPanelItemPathField(label: ContentManager.Labels.panelPath, value: selection?.itemPath)
			}
		}
	}
}

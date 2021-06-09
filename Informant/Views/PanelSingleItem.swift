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

				HStack(spacing: 0) {
					// Kind
					ComponentsPanelItemField(label: ContentManager.Labels.panelKind, value: selection?.itemKind, lineLimit: 2)

					// TODO: This is a really sketchy way to break an interface up. See if there's a better way
					// Size
					if selection?.itemKind?.count != nil && selection!.itemKind!.count <= 16 {
						ComponentsPanelSizeField(selection: selection)
							.padding([.leading], 15)
					}

					Spacer(minLength: 0)
				}

				// Size - if the kind field is too large
				if selection?.itemKind != nil && selection!.itemKind!.count >= 17 {
					ComponentsPanelSizeField(selection: selection)
				}

				// Created
				ComponentsPanelItemField(label: ContentManager.Labels.panelCreated, value: selection?.itemDateCreatedAsString)

				// Path
				ComponentsPanelItemPathField(label: ContentManager.Labels.panelPath, value: selection?.itemPath)
			}
		}
	}
}

/// Size appears in multiple places depending on the layout. This is built to avoid code duplication
struct ComponentsPanelSizeField: View {
	var selection: SingleSelection?
	var body: some View {
		ComponentsPanelItemField(label: ContentManager.Labels.panelSize, value: selection?.itemSizeAsString)
	}
}

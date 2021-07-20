//
//  PanelSingleFrame.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

/// Root single item selection view
struct PanelSingleFrame<Content: View>: View {

	@ObservedObject var interfaceState: InterfaceState

	@ObservedObject var selection: SingleSelection

	var content: Content

	init(_ selection: SelectionProtocol?, @ViewBuilder content: @escaping () -> Content) {
		self.selection = selection as! SingleSelection
		self.content = content()
		self.interfaceState = AppDelegate.current().interfaceState
	}

	var body: some View {

		ComponentsPanelFullFrame {

			ComponentsPanelHeader(
				headerTitle: selection.itemTitle,
				headerIcon: selection.itemIcon,
				headerSubtitle: selection.itemDateModifiedAsString
			)
			.padding([.bottom], 7)

			Divider().padding(.bottom, 10)

			VStack(alignment: .leading, spacing: 15) {

				// Kind & Size
				// We set the second value to calculating so it doesn't resize once it finds the correct calculation
				ComponentsPanelItemStack(firstValue: selection.itemKind, secondValue: SelectionHelper.State.Calculating.localized) {
					ComponentsPanelItemField(label: ContentManager.Labels.panelKind, value: selection.itemKind, lineLimit: 2)
				} secondItem: {
					ComponentsPanelItemField(label: ContentManager.Labels.panelSize, value: selection.itemSizeAsString)
				}

				// Created
				if interfaceState.settingsPanelEnableCreatedProp {
					ComponentsPanelItemField(label: ContentManager.Labels.panelCreated, value: selection.itemDateCreatedAsString)
				}

				// Name
				if interfaceState.settingsPanelEnableNameProp {
					ComponentsPanelItemField(label: ContentManager.Labels.panelName, value: selection.itemTitle, lineLimit: 4)
				}

				// MARK: - Inject content here
				content

				// Tags
				ComponentsPanelTags(tags: selection.selectionTags)

				// Path
				if interfaceState.settingsPanelEnablePathProp, let isPathFullLength = selection.isPathFullLength(interfaceState) {
					ComponentsPanelItemPathField(
						label: isPathFullLength ? ContentManager.Labels.panelPath : ContentManager.Labels.panelWhere,
						value: selection.itemPath
					)
				}
			}
		}
	}
}

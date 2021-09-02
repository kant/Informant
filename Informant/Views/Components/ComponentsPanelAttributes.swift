//
//  ComponentsPanelAttributes.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-30.
//

import SwiftUI

/// Used to display all the file's attributes in the bottom of the panel.
struct ComponentsPanelAttributes: View, PanelProtocol {

	var selection: SingleSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleSelection
	}

	var body: some View {

		// Total attribute stack
		HStack(alignment: .center, spacing: 13) {

			// Hidden file
			if selection?.isHidden == true {
				ComponentsAttribute(icon: ContentManager.Icons.panelHidden, label: ContentManager.Labels.panelHidden)
			}

			// iCloud Container
			if selection?.isiCloudSyncFile == true {
				ComponentsAttribute(icon: ContentManager.Icons.panelCloud, label: "iCloud", iconSize: 11.5)
			}
		}
	}
}

/// A single attribute -> (Hidden, iCloud file, etc.)
struct ComponentsAttribute: View {

	var icon: String
	var label: String
	var iconSize: CGFloat = 10.5

	var body: some View {
		HStack(alignment: .lastTextBaseline, spacing: 3.5) {

			// Icon
			Image(systemName: icon)
				.font(.system(size: iconSize, weight: .semibold))
				.padding([.trailing], 1)

			// Label
			Text(label)
				.PanelTagFont()
		}
		.fixedSize()
		.opacity(0.5)
	}
}

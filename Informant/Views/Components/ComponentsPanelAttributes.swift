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
				ComponentsAttribute(icon: "􀋯", label: "Hidden")
			}

			// iCloud Container
			if selection?.isiCloudSyncFile == true {
				ComponentsAttribute(icon: "􀇂", label: "iCloud", iconSize: 12)
			}
		}
	}
}

/// A single attribute -> (Hidden, iCloud file, etc.)
struct ComponentsAttribute: View {

	var icon: String
	var label: String
	var iconSize: CGFloat = 11

	var body: some View {
		HStack(alignment: .center, spacing: 4) {

			// Icon
			Text(icon)
				.PanelTagFont(size: iconSize)

			// Label
			Text(label)
				.PanelTagFont()
		}
		.fixedSize()
		.opacity(0.5)
	}
}

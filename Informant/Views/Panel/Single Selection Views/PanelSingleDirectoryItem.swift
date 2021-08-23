//
//  PanelSingleDirectoryItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleDirectoryItem: View, PanelProtocol {

	var selection: SingleDirectorySelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleDirectorySelection
	}

	var body: some View {
		PanelSingleFrame(selection) {

			// Total directory count
			ComponentsPanelItemField(label: ContentManager.Labels.panelContains, value: selection?.itemCount)
		}
	}
}

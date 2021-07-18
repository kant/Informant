//
//  PanelSingleApplicationItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleApplicationItem: View, PanelProtocol {

	var selection: SingleApplicationSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleApplicationSelection
	}

	var body: some View {
		PanelSingleFrame(selection) {

			// Version #
			ComponentsPanelItemField(label: ContentManager.Labels.panelVersion, value: selection?.version)
		}
	}
}

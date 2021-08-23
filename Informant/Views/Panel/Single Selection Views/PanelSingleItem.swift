//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// View used when there's no additional metadata for the item
struct PanelSingleItem: View, PanelProtocol {

	var selection: SingleSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleSelection
	}

	var body: some View {
		PanelSingleFrame(selection) {
			EmptyView()
		}
	}
}

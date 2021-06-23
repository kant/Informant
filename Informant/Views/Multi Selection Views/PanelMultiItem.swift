//
//  PopoverMultiFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Shown when multiple files are selected by the user.
struct PanelMultiItem: View, PanelProtocol {

	var selection: MultiSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? MultiSelection
	}

	var body: some View {
		ComponentsPanelReducedFrame {
			ComponentsPanelHeader(
				headerTitle: selection?.itemTitle,
				headerIconCollection: selection?.itemTotalIcons,
				headerSubtitle: selection?.itemSizeAsString
			)
		}
	}
}

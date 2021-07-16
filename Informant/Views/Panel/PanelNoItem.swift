//
//  PopoverNoFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Shown when no files are selected by the user.
struct PanelNoItem: View {
	var body: some View {
		ComponentsPanelReducedFrame {
			Text(ContentManager.Titles.panelNoItemsSelected)
				.H1()
				.opacity(Style.Text.opacity)
				.padding([.top], 1)
		}
	}
}

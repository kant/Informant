//
//  PanelErrorItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-28.
//

import SwiftUI

/// Informs the user that a selection cannot be made.
struct PanelSelectionErrorItem: View {
	var body: some View {
		ComponentsPanelReducedFrame {
			HStack(spacing: 8) {

				Image(systemName: ContentManager.Icons.panelNoAccess)
					.font(.system(size: 15, weight: .semibold))

				Text(ContentManager.Titles.panelErrorTitle)
					.H1()
			}
			.opacity(Style.Text.opacity)
		}
	}
}

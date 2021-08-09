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
				
				Text("􀁎")
					.font(.system(size: 16))

				Text(ContentManager.Titles.panelErrorTitle)
					.H1()
			}
			.opacity(Style.Text.opacity)
		}
	}
}

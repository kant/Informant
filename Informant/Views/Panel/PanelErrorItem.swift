//
//  PanelErrorItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-28.
//

import SwiftUI

/// Informs the user that a selection cannot be made.
struct PanelErrorItem: View {
	var body: some View {
		ComponentsPanelReducedFrame {
			VStack(spacing: 6) {

				Text("􀇾")
					.H1()
					.opacity(Style.Text.opacity)

				Text(ContentManager.Titles.panelErrorTitle)
					.H1()
					.opacity(Style.Text.opacity)
			}
			.padding([.bottom], 9)
		}
		.frame(height: 62)
	}
}

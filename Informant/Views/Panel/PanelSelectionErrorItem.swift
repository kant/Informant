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
		ComponentsPanelErrorFrame(
			icon: "􀇾",
			label: ContentManager.Titles.panelErrorTitle
		)
	}
}

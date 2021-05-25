//
//  PopoverNoFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverNoFile: View {
	var body: some View {
		ComponentsPanelFrame {
			Text(ContentManager.Labels.panelNoItemsSelected)
				.H1()
				.opacity(0.5)

				// Keeps text centered in the middle with some healthy padding
				.padding(.bottom, 5)
				.padding(.top, 27)
		}
	}
}

//
//  PopoverNoFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverNoFile: View {

	let noItemsSelected = NSLocalizedString("No items selected", comment: "String displayed when no items are selected.")

	var body: some View {
		ComponentsPanelFrame {
			Text(noItemsSelected)
				.H1()
				.opacity(0.5)

				// Keeps text centered in the middle with some healthy padding
				.padding(.bottom, 5)
				.padding(.top, 27)
		}
	}
}

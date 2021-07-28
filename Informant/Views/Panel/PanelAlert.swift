//
//  PanelAlert.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-14.
//

import SwiftUI

struct PanelAlert: View {

	let icon: String
	let label: String

	init(icon: String = "􀉁", label: String = ContentManager.Extra.popUpCopied) {
		self.icon = icon
		self.label = label
	}

	var body: some View {
		VStack(spacing: 0) {

			Spacer()

			Text(icon)
				.PanelAlertFont(43)
				.baselineOffset(5)

			Spacer()
				.frame(height: 10.0)

			Text(label)
				.PanelAlertFont(19)

			Spacer()
		}
		.edgesIgnoringSafeArea(.all)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			VisualEffectView(material: .hudWindow, blendingMode: .behindWindow, emphasized: false)
				.edgesIgnoringSafeArea(.all)
		)
	}
}

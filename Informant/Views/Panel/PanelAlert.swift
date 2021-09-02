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

	init(icon: String = ContentManager.Icons.panelAlertCopied, label: String = ContentManager.Extra.popUpCopied) {
		self.icon = icon
		self.label = label
	}

	var body: some View {
		VStack(spacing: 0) {

			Spacer()

			Image(systemName: icon)
				.font(.system(size: 42, weight: .medium, design: .rounded))

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

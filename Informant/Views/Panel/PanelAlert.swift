//
//  PanelAlert.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-14.
//

import SwiftUI

struct PanelAlert: View {

	// TODO: Make this flexible
	/*
	  let icon: String
	  let label: String
	 */

	var body: some View {
		VStack(spacing: 0) {

			Spacer()

			Text("􀉁")
				.PanelAlertFont(43)
				.baselineOffset(5)

			Spacer()
				.frame(height: 10.0)

			Text(ContentManager.Extra.popUpCopied)
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

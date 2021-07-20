//
//  WelcomeView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-13.
//

import SwiftUI

struct AuthAccessibilityView: View {

	var body: some View {

		// Main stack
		VStack(alignment: .center) {

			// Image
			ComponentsWindowAppIcon()

			// Welcome
			Text(ContentManager.WelcomeLabels.authorizeInformant)
				.WelcomeHeaderFont()

			Spacer().frame(height: 5)

			// How to authorize
			Text(ContentManager.WelcomeLabels.authorizeNeedPermission)
				.Body()

			Spacer().frame(height: Style.Padding.welcomeWindow)

			// What to do about lock
			VStack {
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionSystemPreferences, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionSecurity, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionPrivacy, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionScrollAndClick, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionCheckInformant, color: .blue, arrow: false)
			}

			Spacer().frame(height: Style.Padding.welcomeWindow)

			// Lock description
			VStack(spacing: 10) {

				Text(ContentManager.WelcomeLabels.authorizedInstructionClickLock)
					.Body(size: 13, weight: .medium)

				HStack {
					Text("􀎡").Body(weight: .medium)
					Text("→").Body(weight: .medium).opacity(0.65)
					Text("􀎥").Body(weight: .medium)
				}
			}
			.opacity(0.5)
		}
		.padding([.horizontal, .bottom], Style.Padding.welcomeWindow)
		.frame(width: 325)
	}
}

/// This is the little blue box that shows where the user should navigate to
struct SecurityGuidanceBox: View {

	let label: String
	let color: Color
	let arrow: Bool

	private let radius: CGFloat = 10.0

	internal init(label: String, color: Color, arrow: Bool = true) {
		self.label = label
		self.color = color
		self.arrow = arrow
	}

	var body: some View {
		VStack {

			// Label
			Text(label)
				.font(.system(size: 14))
				.fontWeight(.semibold)
				.foregroundColor(color)
				.padding([.horizontal], 10)
				.padding([.vertical], 6)
				.background(
					RoundedRectangle(cornerRadius: radius)
						.fill(color)
						.opacity(0.1)
				)
				.overlay(
					RoundedRectangle(cornerRadius: radius)
						.stroke(color, lineWidth: 1)
						.opacity(0.2)
				)
				.fixedSize()

			// Arrow
			if arrow {
				Text("↓")
					.font(.system(size: 14))
					.fontWeight(.bold)
					.opacity(0.15)
			}
		}
	}
}

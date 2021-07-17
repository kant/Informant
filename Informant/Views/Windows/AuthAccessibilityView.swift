//
//  WelcomeView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-13.
//

import SwiftUI

struct AuthAccessibilityView: View {

	private let appIconSize: CGFloat = 100

	var body: some View {

		// Main stack
		VStack(alignment: .center) {

			// Image
			Image(nsImage: NSImage(named: ContentManager.Images.appIcon) ?? NSImage())
				.resizable()
				.frame(width: appIconSize, height: appIconSize, alignment: .center)

			// Welcome
			Text("Authorize Informant")
				.WelcomeHeaderFont()

			Spacer().frame(height: 5)

			// How to authorize
			Text("Informant needs your permission to read file metadata.")
				.Body()

			Spacer().frame(height: Style.Padding.welcomeWindow)

			// What to do about lock
			VStack {
				SecurityGuidanceBox(label: "Open System Preferences", color: .blue)
				SecurityGuidanceBox(label: "Click Security & Privacy", color: .blue)
				SecurityGuidanceBox(label: "Click Privacy", color: .blue)
				SecurityGuidanceBox(label: "Scroll down and click Accessibility", color: .blue)
				SecurityGuidanceBox(label: "Check Informant", color: .blue, arrow: false)
			}

			Spacer().frame(height: Style.Padding.welcomeWindow)

			// Lock description
			VStack(spacing: 10) {

				Text("If the checkbox is greyed out, click the lock and enter your password.")
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

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

			// Welcome: Authorize Informant
			Text(ContentManager.WelcomeLabels.authorizeInformant)
				.WelcomeHeaderFont()
				.fixedSize(horizontal: false, vertical: true)

			Spacer().frame(height: 5)

			// How to authorize
			Text(ContentManager.WelcomeLabels.authorizeNeedPermission)
				.Body()

			Spacer().frame(height: Style.Padding.welcomeWindow)

			// What to do about lock
			VStack {
				// Accessibility check
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionSystemPreferences, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionSecurity, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionPrivacy, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionScrollAndClick, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionCheckInformant, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionAutomationCheckFinder, color: .blue)
				SecurityGuidanceBox(label: ContentManager.WelcomeLabels.authorizedInstructionRestartInformant, color: .purple, arrow: false) {
					NSApp.terminate(nil)
				}
			}

			Spacer().frame(height: Style.Padding.welcomeWindow)

			// Lock description
			VStack(spacing: 10) {

				Text(ContentManager.WelcomeLabels.authorizedInstructionClickLock)
					.Body(size: 13, weight: .medium)

				HStack {
					Image(systemName: ContentManager.Icons.authLockIcon)
						.font(.system(size: 13, weight: .semibold))
					Image(systemName: ContentManager.Icons.rightArrowIcon)
						.font(.system(size: 11, weight: .bold))
						.opacity(0.7)
					Image(systemName: ContentManager.Icons.authUnlockIcon)
						.font(.system(size: 13, weight: .semibold))
				}
				.opacity(0.85)
			}
			.opacity(0.5)
		}
		.padding([.horizontal, .bottom], Style.Padding.welcomeWindow)
		.frame(width: 350)
	}
}

/// This is the little blue box that shows where the user should navigate to
struct SecurityGuidanceBox: View {

	let label: String
	let color: Color
	let arrow: Bool
	let action: (() -> Void)?

	private let radius: CGFloat = 10.0

	internal init(label: String, color: Color, arrow: Bool = true, action: (() -> Void)? = nil) {
		self.label = label
		self.color = color
		self.arrow = arrow
		self.action = action
	}

	var body: some View {
		VStack {

			// Label
			if action == nil {
				AuthInstructionBlurb(label, color, radius)
			} else if let action = action {
				AuthInstructionBlurb(label, color, radius, hover: true)
					.onTapGesture {
						action()
					}
			}

			// Arrow
			if arrow {
				Image(systemName: ContentManager.Icons.downArrowIcon)
					.font(.system(size: 12, weight: .bold, design: .rounded))
					.opacity(0.15)
					.padding([.vertical], 2)
			}
		}
	}
}

/// This is the actual text blurb used in the AuthAccessibilityView
struct AuthInstructionBlurb: View {

	let label: String
	let color: Color
	let hover: Bool
	let radius: CGFloat

	internal init(_ label: String, _ color: Color, _ radius: CGFloat, hover: Bool = false) {
		self.label = label
		self.color = color
		self.radius = radius
		self.hover = hover
	}

	@State private var isHovering = false

	var body: some View {
		Text(label)
			.font(.system(size: 14))
			.fontWeight(.semibold)
			.lineSpacing(2)
			.multilineTextAlignment(.center)
			.foregroundColor(color)
			.padding([.horizontal], 10)
			.padding([.vertical], 6)
			.background(
				RoundedRectangle(cornerRadius: radius)
					.fill(color)
					.opacity(isHovering ? 0.25 : 0.1)
			)
			.overlay(
				RoundedRectangle(cornerRadius: radius)
					.stroke(color, lineWidth: 1)
					.opacity(0.2)
			)
			.fixedSize(horizontal: false, vertical: true)

			.whenHovered { hovering in
				if hover {
					isHovering = hovering

					if hovering {
						NSCursor.pointingHand.push()
					} else {
						NSCursor.pop()
					}
				}
			}

			.animation(.easeInOut, value: isHovering)
	}
}

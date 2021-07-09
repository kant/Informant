//
//  PanelCloseButton.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-28.
//

import SwiftUI

struct PanelCloseButton: View {

	/// Lets us know if the panel is being hovered
	@ObservedObject var settingsData: InterfaceState

	@State private var buttonPressed: Bool = false

	// Size of the circle's diameter
	private let size: CGFloat = 20

	init() {
		settingsData = AppDelegate.current().interfaceState
	}

	var body: some View {

		VStack(alignment: .center, spacing: 0) {

			ZStack(alignment: .center) {

				// Backing
				VisualEffectView(material: .popover, blendingMode: .behindWindow, emphasized: true)
					.cornerRadius(size)
					.overlay(

						// Adds highlight on press
						Color.primary
							.cornerRadius(size)
							.opacity(buttonPressed ? 0.5 : 0)
					)

				// Shape
				Circle()
					.stroke(Style.Colour.gray_mid, lineWidth: 1)

				// X - mark
				Image("xmark")
					.PanelCloseFont()
			}
			.frame(width: size, height: size)
		}
		.frame(width: size + 2, height: size + 2)
		.opacity(settingsData.isMouseHoveringClose ? 1 : 0)
		.scaleEffect(settingsData.isMouseHoveringClose ? 1 : 0.01)
		.animation(.easeInOut(duration: 0.16))

		// Tap logic
		.inactiveWindowTap { pressed in
			buttonPressed = pressed

			// Makes sure to cancel press if no longer hovering
			if !pressed, settingsData.isMouseHoveringClose {
				settingsData.isMouseHoveringClose = false
				AppDelegate.current().statusBarController?.hideInterfaces()
			}
		}

		// Hovering logic. Please see ContentView for partnering logic
		.whenHovered { hovering in
			if hovering {
				settingsData.closeHoverZone = .Button
			} else {
				settingsData.closeHoverZone = .Panel
			}

			if hovering == false, settingsData.isMouseHoveringPanel == false {
				settingsData.isMouseHoveringClose = false
			}
		}
	}
}

//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// Currently this is what gets displayed in the popover
struct ContentView: View {

	// This contians all information to be displayed on the interface
	var interfaceData: InterfaceData?

	var body: some View {

		VStack(spacing: 8) {
			// Figure out which view to present based on the # of items selected
			if interfaceData?.isNotNil == true {

				// One items selected
				PopoverSingleFile(file: interfaceData!.fileCollection!.files[0])
			}

			// Otherwise if no items are selected
			else {
				PopoverNoFile()
			}

			// Bottom buttons
			HStack(spacing: 0) {

				// Ensures buttons align to the right
				Spacer()

				// Close Button
				ComponentsPanelIconButton(iconName: "xmark.circle", size: 14) {
					print("Close button")
				}

				// Gear button
				ComponentsPanelIconButton(iconName: "gear") {
					print("Gear button")
				}
			}
		}
		// Adding the frame here makes sure it resizes properly
		.frame(width: 265)

		// A Little padding for the panel buttons
		.padding(6)

		// This is the frosted glass effect in action
		.background(VisualEffectView(material: .popover, blendingMode: .behindWindow, emphasized: true))

		// Corner radius setup, DO NOT change the order
		.cornerRadius(15, antialiased: true)
		.fixedSize()
	}
}

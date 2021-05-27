//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// Currently this is what gets displayed in the popover
struct ContentView: View {

	/// This contains the app delegate, which can is used for all functionality
	var appDelegate: AppDelegate

	/// This contians all information to be displayed on the interface
	var interfaceData: ItemCollection?

	// Initialize app delegate object
	init(_ appDelegate: AppDelegate) {
		self.appDelegate = appDelegate
		self.interfaceData = appDelegate.interfaceData
	}

	var body: some View {

		VStack(spacing: 7) {

			// Figure out which view to present based on the # of items selected
			if interfaceData != nil {

				// One items selected
				if interfaceData!.collectionType == .Single {
					PopoverSingleFile(selection: interfaceData!.selectItem)
				}

				// More than one item selected
				else if interfaceData!.collectionType == .Multi {
					PopoverMultiFile(selection: interfaceData!.selectItem)
				}
			}

			// Otherwise if no items are selected
			else {
				PopoverNoFile()
			}

			// MARK: - Bottom buttons
			ZStack {

				// Hide Button
//				if interfaceData?.isNotNil == true {
//					ComponentsPanelIconButton(ContentManager.Icons.panelHideButton, size: 15) {
//						appDelegate.statusBarController?.hideWindow()
//					}
//				}

				// Settings button stack
				HStack(spacing: 0) {

					// Ensures buttons align to the right
					Spacer()

					// More button
					ComponentsPanelIconButton(ContentManager.Icons.panelPreferencesButton) {
						appDelegate.interfaceMenuController?.openMenu()
					}
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

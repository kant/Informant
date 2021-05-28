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
	var interfaceData: Selection?

	// Initialize app delegate object
	init(_ appDelegate: AppDelegate) {
		self.appDelegate = appDelegate
		self.interfaceData = appDelegate.interfaceData
	}

	var body: some View {

		// MARK: - Full NSWindow View
		VStack {

			// MARK: - Panel Main
			ZStack {
				// So we can add padding to the main interface
				VStack {
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
				}
				.padding(10)

				// MARK: - Panel Bottom Buttons
				VStack {

					Spacer()

					ZStack {

						// Hide Button
						//	if interfaceData?.isNotNil == true {
						//		ComponentsPanelIconButton(ContentManager.Icons.panelHideButton, size: 15) {
						//			appDelegate.statusBarController?.hideWindow()
						//		}
						//	}

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
			}
			// Adding the frame here makes sure it resizes properly. Originally 265.0
			.frame(width: 255)

			// A Little padding for the panel buttons
			.padding(6)

			// This is the frosted glass effect in action
			.background(VisualEffectView(material: .popover, blendingMode: .withinWindow, emphasized: true))

			// Corner radius setup, DO NOT change the order
			.cornerRadius(15, antialiased: false)
			.fixedSize()

			// MARK: - Bottom Pumper
			// This spacer is added to make sure the view squishes up to the top
			if interfaceData != nil {
				Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
			}
		}
	}
}

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
	var interfaceData: InterfaceData?

	// Initialize app delegate object
	init() {
		appDelegate = AppDelegate.current()
		interfaceData = appDelegate.interfaceData
	}

	var body: some View {

		// MARK: Full Stacked View
		ZStack {

			// MARK: - Panel Backing Material
			VisualEffectView(material: .menu, blendingMode: .behindWindow, emphasized: true)
				.edgesIgnoringSafeArea(.all)

			// MARK: - Panel Bottom Buttons
			VStack {

				// Makes sure button rests on the bottom of the interface
				Spacer()

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
			.padding(4)

			// MARK: - Panel Main
			// So we can add padding to the main interface
			VStack(alignment: .center, spacing: 0) {

				// Figure out which view to present based on the # of items selected
				if interfaceData != nil {

					// One items selected
					if interfaceData!.selection?.collectionType == .Single {
						PopoverSingleFile(selection: interfaceData?.selection)
					}

					// More than one item selected
					else if interfaceData!.selection?.collectionType == .Multi {
						PopoverMultiFile(selection: interfaceData?.selection)
					}
				}

				// Otherwise if no items are selected
				else {
					PopoverNoFile()
				}
			}
			.padding(.horizontal, 15)
		}
		.frame(width: 256)
		.edgesIgnoringSafeArea(.top)
		.fixedSize()
	}
}

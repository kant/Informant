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

	/// Lets us know if the object is being dragged in the snap zone
	@ObservedObject var settingsData: SettingsData

	// Initialize app delegate object
	init() {
		appDelegate = AppDelegate.current()
		interfaceData = appDelegate.interfaceData
		settingsData = appDelegate.settingsData
	}

	var body: some View {

		// MARK: Full Stacked View
		ZStack {

			// This is the main panel group
			Group {
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
					switch interfaceData?.selection?.selectionType {

					// One item selected
					case .Single: PanelSingleItem(interfaceData?.selection)

					// More than one item selected
					case .Multi: PanelMultiItem(interfaceData?.selection)

					// No items selected
					default: PanelNoItem()
					}
				}
				.padding(.horizontal, 15)
			}

			// Blurs view when being dragged in the snap zone
			.blur(radius: settingsData.isPanelInSnapZone ? 15.0 : 0.0)
			.animation(.easeInOut, value: self.settingsData.isPanelInSnapZone)

			// MARK: - Panel Snap Zone Indicator
			ZStack {
				Text(ContentManager.Labels.panelSnapZoneIndicator).H2()
					.opacity(settingsData.isPanelInSnapZone ? Style.Text.opacity : 0.0)
			}
			.animation(.easeInOut, value: self.settingsData.isPanelInSnapZone)
		}
		.frame(width: 256)
		.edgesIgnoringSafeArea(.top)
		.fixedSize()
	}
}

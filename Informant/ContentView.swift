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
	@ObservedObject var interfaceData: InterfaceDataWrapper

	/// Lets us know if the object is being dragged in the snap zone
	@ObservedObject var interfaceState: InterfaceState

	// Initialize app delegate object
	init() {
		appDelegate = AppDelegate.current()
		interfaceState = appDelegate.interfaceState
		interfaceData = InterfaceDataWrapper(data: appDelegate.interfaceData)
	}

	var body: some View {

		// MARK: Full Stacked View
		ZStack {

			// MARK: - Panel Backing Material
			VisualEffectView(material: .menu, blendingMode: .behindWindow, emphasized: true)
				.edgesIgnoringSafeArea(.all)

			// This is the pause blur group
			Group {

				// Confirm that accessibility is enabled
				if interfaceState.privacyAccessibilityEnabled == true {

					// This is for privacy accessibility
					Group {

						// This is the main panel group
						Group {

							// MARK: - Panel Main
							// So we can add padding to the main interface
							VStack(alignment: .center, spacing: 0) {

								// MARK: - Selection View Picker
								// Figure out which view to present based on the # of items selected
								switch interfaceData.data?.selection?.selectionType {

									// MARK: - Singles
									// One item selected - no metadata
									case .Single: PanelSingleItem(interfaceData.data?.selection)

									// One item selected - with metadata ⤵︎
									case .Image: PanelSingleImageItem(interfaceData.data?.selection)

									case .Movie: PanelSingleMovieItem(interfaceData.data?.selection)

									case .Audio: PanelSingleAudioItem(interfaceData.data?.selection)

									case .Directory: PanelSingleDirectoryItem(interfaceData.data?.selection)

									case .Application: PanelSingleApplicationItem(interfaceData.data?.selection)

									case .Volume: PanelSingleVolumeItem(interfaceData.data?.selection)

									// MARK: - Multi
									// More than one item selected
									case .Multi: PanelMultiItem(interfaceData.data?.selection)

									// Errors
									case .Error: PanelSelectionErrorItem()

									// No items selected
									default: PanelNoItem()
								}
							}
							.padding(.horizontal, 15)
						}

						// MARK: - Is Paused Indicator

						// Blurs view when being dragged in the snap zone
						.blur(radius: interfaceState.settingsPauseApp ? 15.0 : 0.0)
						.animation(.easeOut, value: self.interfaceState.settingsPauseApp)

						ComponentsPanelLabelIconFrame(
							icon: "􀊇",
							iconSize: 16,
							label: ContentManager.SettingsLabels.paused
						)
						.opacity(interfaceState.settingsPauseApp ? 1.0 : 0.0)
						.animation(.easeOut, value: self.interfaceState.settingsPauseApp)

						// When the user clicks on this blurred screen the app resumes operation
						if interfaceState.settingsPauseApp {
							Color.clear
								.inactiveWindowTap { pressed in
									if !pressed {
										interfaceState.settingsPauseApp = false
									}
								}
						}
					}
				}

				// Otherwise show the 'not-authorized' view
				else {
					PanelAuthErrorItem()
				}

				// MARK: - Panel Bottom Buttons

				VStack {

					// Makes sure button rests on the bottom of the interface
					Spacer()

					// Settings button stack
					HStack(spacing: 0) {

						// Additional file tags
						ComponentsPanelAttributes(interfaceData.data?.selection)
							.padding([.leading], 11)
							.blur(radius: interfaceState.settingsPauseApp ? 15.0 : 0.0)
							.animation(.easeOut, value: self.interfaceState.settingsPauseApp)

						// Ensures buttons align to the right
						Spacer()

						// More button
						ComponentsPanelIconMenuButton(ContentManager.Icons.panelPreferencesButton, size: 16.25) {
							appDelegate.interfaceMenuController!.openMenuAtPanel()
						}
					}
				}
				.padding(4)
			}

			// MARK: - Panel Snap Zone Indicator

			// MARK: Rotating Icon
			VStack(spacing: 0) {
				Text("• • •")
					.font(.system(size: 14))
					.opacity(0.25)
					.padding(.top, 2)
				Spacer()
			}
			.opacity(interfaceState.isPanelInSnapZone ? 1.0 : 0.0)
			.animation(.easeOut, value: self.interfaceState.isPanelInSnapZone)

			// When the user clicks on this blurred screen the app resumes operation
			if interfaceState.isPanelInSnapZone {
				Color.clear
					.inactiveWindowTap { pressed in
						if !pressed {
							interfaceState.isPanelInSnapZone = false
						}
					}
			}
		}

		// Please see PanelCloseButton.swift for partnering logic
		.whenHovered { hovering in
			if appDelegate.statusBarController?.interfaceHidingState != .Hidden {

				if interfaceState.closeHoverZone != .Button || hovering {
					interfaceState.isMouseHoveringClose = hovering
				}

				hovering == true ? appDelegate.interfaceCloseController?.setPosition() : ()
				interfaceState.isMouseHoveringPanel = hovering
			}
		}
		.frame(width: 256)
		.edgesIgnoringSafeArea(.top)
		.fixedSize()
	}
}

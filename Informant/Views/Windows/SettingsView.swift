//
//  Preferences.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI

// This is the main settings window view
struct SettingsView: View {

	let appDelegate: AppDelegate!

	let settingsPanelCornerRadius: CGFloat = 10.0

	@ObservedObject var interfaceState: InterfaceState

	init() {
		appDelegate = AppDelegate.current()
		interfaceState = appDelegate.interfaceState
	}

	var body: some View {
		VStack(alignment: .center, spacing: 0) {

			Spacer()

			// Main stack
			HStack(alignment: .center, spacing: 0) {

				// Left side
				SettingsLeftSideView()
					.padding([.horizontal], 22)
					.frame(minWidth: 270)
					.fixedSize()

				// Right side
				ScrollView(.vertical, showsIndicators: true, content: {
					SettingsRightSideView(interfaceState: interfaceState)
						.padding([.trailing], 55)
						.padding([.leading], 35)
						.padding([.top], 20)
						.padding([.bottom], 25)
				})

					// Clips the content to fit in the scroll view
					.clipped()

					// The padding below offsets the stroke so aligned outside the view, not in the centre
					.background(
						RoundedRectangle(cornerRadius: settingsPanelCornerRadius)
							.fill(Color.settingsPanelBacking)
					)
					.padding([.all], 0.5)
					.overlay(
						RoundedRectangle(cornerRadius: settingsPanelCornerRadius)
							.stroke(Color.gray)
							.opacity(0.4)
					)

					// Additional alignment
					.padding([.trailing], 24)
			}

			Spacer()
		}
		.padding([.vertical], 15)
		.edgesIgnoringSafeArea(.all)
	}
}

struct SettingsLeftSideView: View {

	var version: String!
	var name: String!

	let linkIcon = "→ "

	init() {

		let info = Bundle.main.infoDictionary

		if let appVersion = info?["CFBundleShortVersionString"] as? String {
			version = appVersion
		}

		if let appName = info?["CFBundleName"] as? String {
			name = appName
		}
	}

	/// Checks state for hovering on packages link
	@State var packagesHovering: Bool = false

	/// Checks state for hovering on releases link
	@State var releasesHovering: Bool = false

	var body: some View {
		VStack(alignment: .center) {

			Spacer()

			// App image stack
			VStack(spacing: 6) {

				// App icon
				Image(nsImage: NSImage(named: ContentManager.Images.appIcon) ?? NSImage())
					.offset(y: 9.0)

				// Name
				if let name = name {
					Text(name)
						.font(.system(size: 25))
						.fontWeight(.medium)
				}

				// Copyright
				Text("©2021 Ty Irvine")
					.SettingsVersionFont()

				// MARK: Acknowledgements & Version
				HStack(spacing: 4) {

					// Packages
					ComponentsSmallLink(label: ContentManager.SettingsLabels.acknowledgements, hovering: $packagesHovering) {
						LinkHelper.openPDF(link: Links.acknowledgements)
					}

					// Divider
					Text("•")
						.SettingsVersionFont()

					// Packages
					ComponentsSmallLink(label: ContentManager.SettingsLabels.releases, hovering: $releasesHovering) {
						LinkHelper.openLink(link: Links.releases)
					}
				}

				// Version
				if let version = version {
					Text(version)
						.SettingsVersionFont()
				}
			}

			Spacer().frame(height: 22)

			// Link stack
			VStack(alignment: .leading, spacing: 12) {

				// Privacy policy
				ComponentsPanelLabelButton {
					LinkHelper.openLink(link: Links.privacyPolicy)
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.privacyPolicy)
						.SettingsLabelButtonFont()
				}

				// Feedback
				ComponentsPanelLabelButton {
					LinkHelper.openLink(link: Links.feedback)
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.feedback)
						.SettingsLabelButtonFont()
				}

				// Help
				ComponentsPanelLabelButton {
					LinkHelper.openLink(link: Links.help)
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.help)
						.SettingsLabelButtonFont()
				}
			}
			.padding(.leading, 4)

			Spacer()
		}
	}
}

struct SettingsRightSideView: View {

	@ObservedObject var interfaceState: InterfaceState

	private let hstackTogglePadding: CGFloat = 18
	private let sectionVerticalPadding: CGFloat = 30

	var body: some View {

		// Panel and system preferences
		VStack(alignment: .leading, spacing: 0) {

			// For determining fixed size
			Group {

				// MARK: - Menu Bar

				// Menu label
				Text(ContentManager.SettingsLabels.menubar)
					.SettingsLabelFont(padding: 11)

				// Menu bar icon
				Picker(ContentManager.SettingsLabels.menubarIcon, selection: $interfaceState.settingsMenubarIcon) {

					Text(ContentManager.MenubarIcons.noIcon)
						.tag(ContentManager.MenubarIcons.menubarBlank)

					Image(ContentManager.MenubarIcons.menubarDefault + "-picker")
						.tag(ContentManager.MenubarIcons.menubarDefault)

					Image(ContentManager.MenubarIcons.menubarDoc + "-picker")
						.tag(ContentManager.MenubarIcons.menubarDoc)

					Image(ContentManager.MenubarIcons.menubarInfo + "-picker")
						.tag(ContentManager.MenubarIcons.menubarInfo)

					Image(ContentManager.MenubarIcons.menubarDrive + "-picker")
						.tag(ContentManager.MenubarIcons.menubarDrive)

					Image(ContentManager.MenubarIcons.menubarFolder + "-picker")
						.tag(ContentManager.MenubarIcons.menubarFolder)

					Image(ContentManager.MenubarIcons.menubarViewfinder + "-picker")
						.tag(ContentManager.MenubarIcons.menubarViewfinder)
				}
				.pickerStyle(PopUpButtonPickerStyle())
				.layoutPriority(-2)
				.padding([.bottom], 14)
				.padding([.vertical], 3)

				// Menu bar settings stack
				VStack(alignment: .leading, spacing: 21) {

					// MARK: - General

					ComponentsSettingsToggleSection(ContentManager.SettingsLabels.menubarSectionsGeneral) {

						TogglePadded(ContentManager.SettingsLabels.menubarShowSize, isOn: $interfaceState.settingsMenubarShowSize).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowKind, isOn: $interfaceState.settingsMenubarShowKind).disabled(!interfaceState.settingsMenubarUtilityBool)

					} secondColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowCreated, isOn: $interfaceState.settingsMenubarShowCreated).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowEdited, isOn: $interfaceState.settingsMenubarShowModified).disabled(!interfaceState.settingsMenubarUtilityBool)

					} thirdColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowVersion, isOn: $interfaceState.settingsMenubarShowVersion).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowItems, isOn: $interfaceState.settingsMenubarShowItems).disabled(!interfaceState.settingsMenubarUtilityBool)
					}

					// MARK: - Images

					ComponentsSettingsToggleSection(ContentManager.SettingsLabels.menubarSectionsImages) {

						TogglePadded(ContentManager.SettingsLabels.menubarShowAperture, isOn: $interfaceState.settingsMenubarShowAperture).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowCamera, isOn: $interfaceState.settingsMenubarShowCamera).disabled(!interfaceState.settingsMenubarUtilityBool)

					} secondColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowShutterspeed, isOn: $interfaceState.settingsMenubarShowShutterSpeed).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowFocalLength, isOn: $interfaceState.settingsMenubarShowFocalLength).disabled(!interfaceState.settingsMenubarUtilityBool)

					} thirdColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowISO, isOn: $interfaceState.settingsMenubarShowISO).disabled(!interfaceState.settingsMenubarUtilityBool)
					}

					// MARK: - Media

					ComponentsSettingsToggleSection(ContentManager.SettingsLabels.menubarSectionsMedia) {

						TogglePadded(ContentManager.SettingsLabels.menubarShowVideoBitrate, isOn: $interfaceState.settingsMenubarShowVideoBitrate).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowColorProfile, isOn: $interfaceState.settingsMenubarShowColorProfile).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowCodecs, isOn: $interfaceState.settingsMenubarShowCodecs).disabled(!interfaceState.settingsMenubarUtilityBool)

					} secondColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowAudioBitrate, isOn: $interfaceState.settingsMenubarShowAudioBitrate).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowSampleRate, isOn: $interfaceState.settingsMenubarShowSampleRate).disabled(!interfaceState.settingsMenubarUtilityBool)

					} thirdColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowDimensions, isOn: $interfaceState.settingsMenubarShowDimensions).disabled(!interfaceState.settingsMenubarUtilityBool)

						TogglePadded(ContentManager.SettingsLabels.menubarShowDuration, isOn: $interfaceState.settingsMenubarShowDuration).disabled(!interfaceState.settingsMenubarUtilityBool)
					}

					// MARK: - Volume

					ComponentsSettingsToggleSection(ContentManager.SettingsLabels.menubarSectionsVolume) {

						TogglePadded(ContentManager.SettingsLabels.menubarShowVolumeTotal, isOn: $interfaceState.settingsMenubarShowVolumeTotal).disabled(!interfaceState.settingsMenubarUtilityBool)
					} secondColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowVolumeAvailable, isOn: $interfaceState.settingsMenubarShowVolumeAvailable).disabled(!interfaceState.settingsMenubarUtilityBool)
					} thirdColumn: {

						TogglePadded(ContentManager.SettingsLabels.menubarShowVolumePurgeable, isOn: $interfaceState.settingsMenubarShowVolumePurgeable).disabled(!interfaceState.settingsMenubarUtilityBool)
					}
				}

				// Divides menubar and panel
				Spacer().frame(height: sectionVerticalPadding)

				// MARK: - Panel
				Text(ContentManager.SettingsLabels.panel)
					.SettingsLabelFont()

				VStack(alignment: .leading, spacing: 12) {

					// Shortcut to activate panel
					HStack {
						Text(ContentManager.SettingsLabels.toggleDetailsPanel)
						KeyboardShortcuts.Recorder(for: .togglePopover)
					}

					// Panel toggle stack
					HStack(spacing: hstackTogglePadding) {

						// Name & date created
						VStack(alignment: .leading, spacing: 10) {
							// Hide name property
							TogglePadded(ContentManager.SettingsLabels.hideName, isOn: $interfaceState.settingsPanelHideNameProp)

							// Hide created property
							TogglePadded(ContentManager.SettingsLabels.hideCreated, isOn: $interfaceState.settingsPanelHideCreatedProp)
						}

						// Path properties
						VStack(alignment: .leading, spacing: 10) {

							// Hide icon property
							TogglePadded(ContentManager.SettingsLabels.hideIcon, isOn: $interfaceState.settingsPanelHideIconProp)

							// Hide path property
							TogglePadded(ContentManager.SettingsLabels.hidePath, isOn: $interfaceState.settingsPanelHidePathProp)
						}
					}
				}

				// Divides system and panel
				Spacer().frame(height: sectionVerticalPadding)
			}
			.fixedSize()

			// MARK: - System
			Text(ContentManager.SettingsLabels.system)
				.SettingsLabelFont(padding: 11)

			VStack(alignment: .leading, spacing: 12) {

				// Enable menubar-utility
				TogglePadded(ContentManager.SettingsLabels.menubarUtilityShow, isOn: $interfaceState.settingsMenubarUtilityBool)

				// Show where a selected file is located instead of the full path
				TogglePadded(ContentManager.SettingsLabels.showFullPath, isOn: $interfaceState.settingsPanelDisplayFullPath)

				// Skips the sizing of directories all together
				TogglePadded(ContentManager.SettingsLabels.skipDirectories, isOn: $interfaceState.settingsPanelSkipDirectories)

				// Launch informant on system startup
				LaunchAtLogin.Toggle {
					Text(ContentManager.SettingsLabels.launchOnStartup).togglePadding()
				}
			}
		}
	}
}

/*
 struct SettingsPickRootURL: View {

 	let rootURL: String?

 	@State var isHovering: Bool = false

 	let textAlignment: TextAlignment

 	let windowRef: NSWindow

 	let fixedWidth: Bool

 	init(_ rootURL: String?, _ windowRef: NSWindow = AppDelegate.current().settingsWindow, _ textAlignment: TextAlignment = .leading, fixedWidth: Bool = true) {
 		self.rootURL = rootURL
 		self.textAlignment = textAlignment
 		self.windowRef = windowRef
 		self.fixedWidth = fixedWidth
 	}

 	// Gradient stops
 	let firstStop = Gradient.Stop(color: .primary, location: 0.75)
 	let secondStop = Gradient.Stop(color: .clear, location: 1.0)

 	var body: some View {

 		// Descriptor
 		VStack(alignment: textAlignment == .leading ? .leading : .center) {

 			// Root URL Stack
 			HStack {

 				// Label
 				Text(ContentManager.SettingsLabels.pickRootURL)

 				// Button
 				ZStack {

 					// Backing
 					RoundedRectangle(cornerRadius: 7)
 						.opacity(isHovering ? 0.15 : 0.07)
 						.animation(.easeInOut(duration: 0.25), value: isHovering)

 					// Root url
 					ScrollView(.horizontal, showsIndicators: false) {
 						Text(rootURL ?? ContentManager.SettingsLabels.none)
 							.PanelPathFont(size: 12)
 							.padding(4)
 							.padding([.leading], 5)
 							.opacity(rootURL != nil ? 1 : 0.5)
 					}
 					.mask(
 						// Gradient text
 						LinearGradient(gradient: .init(stops: [firstStop, secondStop]), startPoint: .leading, endPoint: .trailing)
 							.padding([.trailing], 21)
 					)

 					// Clear button stack
 					HStack {

 						Spacer()

 						// Clear button
 						ComponentsPanelIconButton("xmark.circle.fill", size: 13.5) {
 							securityBookmarkHelper.deleteRootURLPermission()
 						}
 					}
 				}
 				.frame(height: 22)
 				.whenHovered { hovering in
 					isHovering = hovering
 				}
 				.onTapGesture {
 					securityBookmarkHelper.pickRootURL(windowRef)
 				}
 			}

 			// Descriptor
 			Text(ContentManager.Messages.settingsRootURLDescriptor)
 				.SettingsVersionFont(lineSpacing: 2.5)
 				.fixedSize(horizontal: false, vertical: true)
 				.multilineTextAlignment(textAlignment)
 		}
 		.frame(width: fixedWidth ? 275 : nil)
 	}
 }
 */

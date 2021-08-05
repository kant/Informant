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
					.frame(width: 270)

				// Divider
				Divider()
					.padding(.vertical, 10)

				// Right side
				SettingsRightSideView(interfaceState: interfaceState)
					.frame(minWidth: 0, maxWidth: .infinity)
					.padding(.bottom, 4)
			}

			Spacer()
		}
		.edgesIgnoringSafeArea(.all)
		.frame(width: 670)
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

				// Version
				if let version = version {
					Text(version)
						.SettingsVersionFont()
				}
			}

			Spacer().frame(height: 22)

			#warning("Add link functionality")
			// Link stack
			VStack(alignment: .leading, spacing: 12) {

				// Acknowledgements
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.privacyPolicy)
						.SettingsLabelButtonFont()
				}

				// Feedback
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text(linkIcon + ContentManager.SettingsLabels.feedback)
						.SettingsLabelButtonFont()
				}

				// Help
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
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

	private let hstackTogglePadding: CGFloat = 16
	private let sectionVerticalPadding: CGFloat = 26

	var body: some View {

		// Panel and system preferences
		VStack(alignment: .leading, spacing: 0) {

			// MARK: - Menu Bar

			// Menu bar and descriptor
			VStack(alignment: .leading, spacing: 4) {

				// Menu label
				Text(ContentManager.SettingsLabels.menubar)
					.SettingsLabelFont(padding: 0)
			}
			.padding(.bottom, 11)

			// Menu bar settings stack
			HStack(alignment: .top, spacing: hstackTogglePadding) {
				Toggle(ContentManager.SettingsLabels.menubarShowSize.toggleLabel(), isOn: $interfaceState.settingsMenubarShowSize).disabled(!interfaceState.settingsMenubarUtilityBool)
				Toggle(ContentManager.SettingsLabels.menubarShowKind.toggleLabel(), isOn: $interfaceState.settingsMenubarShowKind).disabled(!interfaceState.settingsMenubarUtilityBool)
				Toggle(ContentManager.SettingsLabels.menubarShowDimensions.toggleLabel(), isOn: $interfaceState.settingsMenubarShowDimensions).disabled(!interfaceState.settingsMenubarUtilityBool)
				Toggle(ContentManager.SettingsLabels.menubarShowDuration.toggleLabel(), isOn: $interfaceState.settingsMenubarShowDuration).disabled(!interfaceState.settingsMenubarUtilityBool)
			}

			// Divides menubar and panel
			Spacer().frame(height: sectionVerticalPadding)

			// MARK: - Panel
			Text(ContentManager.SettingsLabels.panel)
				.SettingsLabelFont(padding: 7)

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
						Toggle(ContentManager.SettingsLabels.hideName.toggleLabel(), isOn: $interfaceState.settingsPanelHideNameProp)

						// Hide created property
						Toggle(ContentManager.SettingsLabels.hideCreated.toggleLabel(), isOn: $interfaceState.settingsPanelHideCreatedProp)
					}

					// Path properties
					VStack(alignment: .leading, spacing: 10) {

						// Hide icon property
						Toggle(ContentManager.SettingsLabels.hideIcon.toggleLabel(), isOn: $interfaceState.settingsPanelHideIconProp)

						// Hide path property
						Toggle(ContentManager.SettingsLabels.hidePath.toggleLabel(), isOn: $interfaceState.settingsPanelHidePathProp)
					}
				}
			}

			// Divides system and panel
			Spacer().frame(height: sectionVerticalPadding)

			// MARK: - System
			Text(ContentManager.SettingsLabels.system)
				.SettingsLabelFont()

			VStack(alignment: .leading, spacing: 12) {

				// Pick root url
				SettingsPickRootURL(interfaceState.settingsRootURL)

				// Enable menubar-utility
				Toggle(ContentManager.SettingsLabels.menubarUtilityShow.toggleLabel(), isOn: $interfaceState.settingsMenubarUtilityBool)

				// Show where a selected file is located instead of the full path
				Toggle(ContentManager.SettingsLabels.showFullPath.toggleLabel(), isOn: $interfaceState.settingsPanelDisplayFullPath)

				// Skips the sizing of directories all together
				Toggle(ContentManager.SettingsLabels.skipDirectories.toggleLabel(), isOn: $interfaceState.settingsPanelSkipDirectories)

				// Launch informant on system startup
				LaunchAtLogin.Toggle(ContentManager.SettingsLabels.launchOnStartup.toggleLabel())
			}
		}
		.fixedSize()
	}
}

struct SettingsPickRootURL: View {

	let rootURL: String?

	@State var isHovering: Bool = false

	let securityBookmarkHelper: SecurityBookmarkHelper

	let textAlignment: TextAlignment

	let windowRef: NSWindow

	init(_ rootURL: String?, _ windowRef: NSWindow = AppDelegate.current().settingsWindow, _ textAlignment: TextAlignment = .leading) {
		self.rootURL = rootURL
		self.textAlignment = textAlignment
		self.windowRef = windowRef
		securityBookmarkHelper = AppDelegate.current().securityBookmarkHelper
	}

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
							.PanelPathFont()
							.padding(4)
							.padding([.leading], 5)
							.opacity(rootURL != nil ? 1 : 0.5)
					}

					// Clear button stack
					HStack {

						Spacer()

						// Clear button
						ComponentsPanelIconButton("xmark.circle.fill", size: 13.5) {
							securityBookmarkHelper.deleteRootURLPermission()
						}
					}
				}
				.fixedSize(horizontal: false, vertical: true)
				.whenHovered { hovering in
					isHovering = hovering
				}
				.onTapGesture {
					securityBookmarkHelper.pickRootURL(windowRef)
				}
			}

			// Descriptor
			Text(ContentManager.Messages.settingsRootURLDescriptor)
				.SettingsVersionFont()
				.multilineTextAlignment(textAlignment)
		}
		.frame(width: 275)
	}
}

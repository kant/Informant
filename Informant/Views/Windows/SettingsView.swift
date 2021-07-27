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
					.frame(width: 260)

				// Divider
				Divider()
					.padding(.vertical, 12)

				// Right side
				SettingsRightSideView(interfaceState: interfaceState)
					.frame(width: 400)
			}

			Spacer()
		}
		.edgesIgnoringSafeArea(.all)
		.frame(width: 670, height: 420)
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

	private let hstackTogglePadding: CGFloat = 15
	private let sectionVerticalPadding: CGFloat = 25

	var body: some View {

		// Panel and system preferences
		VStack(alignment: .leading, spacing: 0) {

			// MARK: - Menu Bar
			Text(ContentManager.SettingsLabels.menubar)
				.SettingsLabelFont()

			// Menu bar settings stack
			HStack(spacing: hstackTogglePadding) {

				VStack(alignment: .leading, spacing: 10) {
					Toggle(ContentManager.SettingsLabels.menubarShowSize, isOn: $interfaceState.settingsMenubarShowSize)
					Toggle(ContentManager.SettingsLabels.menubarShowKind, isOn: $interfaceState.settingsMenubarShowKind)
				}

				VStack(alignment: .leading, spacing: 10) {
					Toggle(ContentManager.SettingsLabels.menubarShowDateCreated, isOn: $interfaceState.settingsMenubarShowDateCreated)
					Toggle(ContentManager.SettingsLabels.menubarShowPath, isOn: $interfaceState.settingsMenubarShowPath)
				}
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
						// Enable name property
						Toggle(" " + ContentManager.SettingsLabels.enableName, isOn: $interfaceState.settingsPanelHideNameProp)

						// Enable created property
						Toggle(" " + ContentManager.SettingsLabels.enableCreated, isOn: $interfaceState.settingsPanelHideCreatedProp)
					}

					// Path properties
					VStack(alignment: .leading, spacing: 10) {
						// Show where a selected file is located instead of the full path
						Toggle(" " + ContentManager.SettingsLabels.showFullPath, isOn: $interfaceState.settingsPanelDisplayFullPath)

						// Enable path property
						Toggle(" " + ContentManager.SettingsLabels.enablePath, isOn: $interfaceState.settingsPanelHidePathProp)
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

				// Skips the sizing of directories all together
				Toggle(" " + ContentManager.SettingsLabels.skipDirectories, isOn: $interfaceState.settingsPanelSkipDirectories)

				// Launch informant on system startup
				LaunchAtLogin.Toggle(" " + ContentManager.SettingsLabels.launchOnStartup)

				// Enable menubar-utility
				Toggle(" " + ContentManager.SettingsLabels.menubarUtility, isOn: $interfaceState.settingsMenubarUtilityBool)
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

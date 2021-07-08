//
//  Preferences.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import KeyboardShortcuts
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

		// Main stack
		HStack {

			// Left side
			SettingsLeftSideView()
				.frame(width: 260)

			// Divider
			Divider()
			Spacer(minLength: 0)

			// Right side
			SettingsRightSideView(interfaceState: interfaceState)

			// Makes sure view is centered
			Spacer(minLength: 0)
		}
		.padding([.bottom, .leading, .trailing])
		.frame(width: 650, height: 400, alignment: .center)
	}
}

struct SettingsLeftSideView: View {

	var version: String!
	var name: String!

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
				Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
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

			Spacer()

			#warning("Put these into the content manager!")
			// Link stack
			VStack(alignment: .leading, spacing: 12) {

				// Acknowledgements
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text("→ Privacy Policy")
						.SettingsLabelButtonFont()
				}

				// Feedback
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text("→ Feedback")
						.SettingsLabelButtonFont()
				}

				// Help
				ComponentsPanelLabelButton {
					// TODO: Add button functionality
				} content: {
					Text("→ Help")
						.SettingsLabelButtonFont()
				}
			}

			Spacer()
		}
	}
}

struct SettingsRightSideView: View {

	@ObservedObject var interfaceState: InterfaceState

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {

			// MARK: - System
			Text("System")
				.SettingsLabelFont()

			VStack(alignment: .leading, spacing: 12) {

				// Pick root url
				if let rootURL = interfaceState.settingsRootURL {
					SettingsPickRootURL(rootURL: rootURL)
				}

				// Launch informant on system startup
				Toggle(" " + ContentManager.SettingsLabels.launchOnStartup, isOn: $interfaceState.settingsSystemStartupBool)

				// Enable menubar-utility
				Toggle(" " + ContentManager.SettingsLabels.menubarUtility, isOn: $interfaceState.settingsMenubarUtilityBool)
			}

			// Divides system and panel
			Spacer().frame(height: 30)

			// MARK: - Panel
			Text("Panel")
				.SettingsLabelFont(padding: 7)

			VStack(alignment: .leading, spacing: 12) {

				// Shortcut to activate panel
				HStack {
					Text(ContentManager.SettingsLabels.toggleDetailsPanel)
					KeyboardShortcuts.Recorder(for: .togglePopover)
				}

				// Show where a selected file is located instead of the full path
				Toggle(" " + ContentManager.SettingsLabels.showFullPath, isOn: $interfaceState.settingsPanelShowFullPath)

				// Enable created property
				Toggle(" " + ContentManager.SettingsLabels.enableCreated, isOn: $interfaceState.settingsPanelEnableCreatedProp)

				// Enable path property
				Toggle(" " + ContentManager.SettingsLabels.enablePath, isOn: $interfaceState.settingsPanelEnablePathProp)

				// Enable name property
				Toggle(" " + ContentManager.SettingsLabels.enableName, isOn: $interfaceState.settingsPanelEnableNameProp)
			}
		}
		.fixedSize()
	}
}

struct SettingsPickRootURL: View {

	let rootURL: String

	@State var isHovering: Bool = false

	var body: some View {

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
					Text(rootURL)
						.PanelPathFont()
						.padding(5)
				}
				.frame(width: 200)

				// Clear button
				HStack {
					// Button goes here
				}
			}
			.fixedSize(horizontal: false, vertical: true)
			.whenHovered { hovering in
				isHovering = hovering
			}
			.onTapGesture {
				AppDelegate.current().securityBookmarkHelper.pickRootURL()
			}
		}
	}
}

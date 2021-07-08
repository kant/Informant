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
			SettingsRightSideView()

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
	var body: some View {
		VStack(alignment: .center) {

			// Launch informant on system startup

			// Disable menubar-utility size finder

			// Shortcut to activate panel

			// Pick root url

			// Toggle 'where' or 'full path'

			// Show name

			// Show path

			// Show created
		}
	}
}

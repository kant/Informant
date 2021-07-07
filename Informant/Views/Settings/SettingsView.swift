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

			// Makes sure view is centered
			Spacer(minLength: 0)

			// Left side
			SettingsLeftSideView()

			// Divider
			Spacer(minLength: 0)
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

	let version: String!

	init() {
		if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			version = appVersion
		} else {
			version = nil
		}
	}

	var body: some View {
		VStack(alignment: .center) {

			// App icon
			Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())

			// Name
			
			
			// Version
			if version != nil {
				Text(version)
			}


			// Help

			// Feedback
		}
	}
}

struct SettingsRightSideView: View {
	var body: some View {
		VStack(alignment: .center) {
			Text("Right Side")
		}
	}
}

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

			Spacer(minLength: 0)

			// Left side
			VStack(alignment: .center) {
				Text("Left Side")
			}

			Spacer(minLength: 0)

			Divider()

			Spacer(minLength: 0)

			// Right side
			VStack(alignment: .center) {
				Text("Right Side")
			}

			Spacer(minLength: 0)
		}
		.padding([.bottom, .leading, .trailing])
		.frame(width: 650, height: 400, alignment: .center)
	}
}

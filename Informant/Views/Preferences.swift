//
//  Preferences.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import KeyboardShortcuts
import SwiftUI

struct Preferences: View {
	var body: some View {
		HStack {
			Text("Set a shortcut to find info")
			KeyboardShortcuts.Recorder(for: .togglePopover)
		}
	}
}

struct Preferences_Previews: PreviewProvider {
	static var previews: some View {
		Preferences()
	}
}

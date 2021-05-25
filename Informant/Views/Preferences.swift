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
			Text(ContentManager.Labels.preferencesShortcutsDisplayDetailPanel)
			KeyboardShortcuts.Recorder(for: .togglePopover)
		}
	}
}

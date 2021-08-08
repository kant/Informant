//
//  PanelNoAuth.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-16.
//

import SwiftUI

struct PanelAuthErrorItem: View {
	var body: some View {
		ComponentsPanelErrorFrame(
			icon: "􀎣",
			label: ContentManager.Labels.panelUnauthorized,
			spacing: 6,
			buttonLabel: ContentManager.Labels.panelAuthorize) {

				// Open the window to get the user to enable accessibility access
				AppDelegate.current().privacyAccessibilityWindowController.open()
		}
	}
}

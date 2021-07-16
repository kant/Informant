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
			label: "Unauthorized",
			padding: 0,
			buttonLabel: "Authorize") {

				// Open the window to get the user to enable accessibility access
				AppDelegate.current().authWindowController.open()
		}
	}
}

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
			buttonLabel: "Authorize") {
				print("Time to auth")
		}
	}
}

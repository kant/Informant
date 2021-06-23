//
//  PanelSingleDirectoryItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleDirectoryItem: View, PanelProtocol {

	var selection: SingleDirectorySelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleDirectorySelection
	}

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

//
//  PanelSingleAudioItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleAudioItem: View, PanelProtocol {

	var selection: SingleAudioSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleAudioSelection
	}

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

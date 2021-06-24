//
//  PanelSingleApplicationItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleApplicationItem: View, PanelProtocol {

	var selection: SingleApplicationSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleApplicationSelection
	}

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

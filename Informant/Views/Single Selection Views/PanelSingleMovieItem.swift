//
//  PanelSingleMovieItem.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import SwiftUI

struct PanelSingleMovieItem: View {

	var selection: SingleMovieSelection?

	init(_ selection: SelectionProtocol?) {
		self.selection = selection as? SingleMovieSelection
	}

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

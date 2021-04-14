//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
//		Text("What's poppin")
		Preferences()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

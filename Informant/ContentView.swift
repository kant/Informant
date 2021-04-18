//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// Currently this is what gets displayed in the popover
struct ContentView: View {

	@ObservedObject var files: FileCollection

	var body: some View {
		VStack {

			// File info
			if files.files[0].fileName != nil {
				Text(files.files[0].fileName!)
			}

			// Temp
			Preferences()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

//
// struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
// }

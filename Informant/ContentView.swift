//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// Currently this is what gets displayed in the popover
struct ContentView: View {

	var interfaceData: InterfaceData?

	var body: some View {
		VStack {

			// Figure out which view to present based on the # of items selected
			if interfaceData != nil {
				if interfaceData!.fileCollection!.files[0].fileName != nil {
					// One item selected
					PopoverSingleFile(file: interfaceData!.fileCollection!.files[0])

					// Multiple item selected

					// No item selected
				}
			}

			// Temp
			Preferences()
		}
		.padding(15)
	}
}

//
// struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
// }


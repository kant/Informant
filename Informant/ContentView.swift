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

			VStack {
				// Figure out which view to present based on the # of items selected
				if interfaceData != nil && interfaceData!.fileCollection != nil {
					if interfaceData!.fileCollection!.files[0].fileName != nil {
						// One item selected
						PopoverSingleFile(file: interfaceData!.fileCollection!.files[0])

						// Multiple item selected
						// ?
						// No item selected
					}
				}

				// Temp
				Preferences()
			}
			.padding(15)
		}
		.background(VisualEffectView(material: .popover, blendingMode: .behindWindow))
		.cornerRadius(10, antialiased: true)
		.frame(width: 290, height: 300)
		.fixedSize()
	}
}

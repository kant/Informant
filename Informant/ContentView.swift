//
//  ContentView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import SwiftUI

// TODO: Clean this up
// Currently this is what gets displayed in the popover
struct ContentView: View {

	var interfaceData: InterfaceData?

	var body: some View {

		VStack {

			// This internal VStack gets a padded edge
			VStack {
				// Figure out which view to present based on the # of items selected
				if interfaceData?.isNotNil == true {

					// One item selected
					PopoverSingleFile(file: interfaceData!.fileCollection!.files[0])
				}

				// Temporary, get rid of it lol
				Preferences()
			}
			// Adding the frame here makes sure it resizes properly
			.frame(width: 250)
			.padding(15)
		}
		// This is the frosted glass effect in action
		.background(VisualEffectView(material: .popover, blendingMode: .behindWindow, emphasized: false))

		// Corner radius setup, DO NOT change the order
		.cornerRadius(10, antialiased: true)
		.fixedSize()
	}
}

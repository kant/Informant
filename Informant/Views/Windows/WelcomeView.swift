//
//  WelcomeView.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-13.
//

import SwiftUI

struct WelcomeView: View {

	private let appIconSize: CGFloat = 90

	var body: some View {

		// Main stack
		HStack {

			// Content
			VStack(alignment: .leading) {

				// Image
				Image(nsImage: NSImage(named: ContentManager.Images.appIcon) ?? NSImage())
					.resizable()
					.frame(width: appIconSize, height: appIconSize, alignment: .center)
					.offset(x: -8, y: 0)

				// Welcome
				Text("Please authorize Informant")
					.font(.system(size: 25))
					.fontWeight(.bold)

				Spacer().frame(height: 5)

				// How to authorize
				Text("Informant needs your permission to read file metadata.")
					.font(.system(size: 15))

				Spacer().frame(height: 15)

				// What to do about lock

				Spacer()
			}

			// Pushes content to the left
			Spacer()
		}
		.padding([.horizontal, .bottom], 30)
		.frame(width: 700, height: 250)
	}
}

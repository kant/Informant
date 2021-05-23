//
//  ComponentsPopover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

// MARK: - Panel Fonts

struct ComponentsPanelHeader: View {

	var headerIcon: NSImage
	var headerTitle: String
	var headerSubtitle: String

	var body: some View {
		HStack {
			// Icon
			Image(nsImage: headerIcon).resizable().frame(width: 42, height: 42)

			VStack(alignment: .leading) {
				// Title
				Text(headerTitle).H1().lineLimit(1)

				// Subtitle
				Text(headerSubtitle).H2()
			}

			Spacer()
		}
	}
}

// MARK: - Panel Big Blocks

struct ComponentsPanelFull<Content>: View where Content: View {

	var content: Content

	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content()
	}

	var body: some View {
		VStack(alignment: .leading) {
			content
		}

		// Adds padding to everything except the bottom
		.padding([.top, .leading, .trailing], 10)
		.padding(.bottom, 0)
	}
}

struct ComponentsPanelItemAttribute: View {

	var label: String
	var value: String

	var body: some View {
		VStack(alignment: .leading) {
			// Label
			Text(label).H2()

			// Value
			Text(value).H1()
		}
	}
}

// MARK: - Panel Buttons

struct ComponentsPanelIconButton: View {

	var iconName: String
	/// Default size is 15.0
	var size: CGFloat = 15
	var action: () -> Void

	var body: some View {
		Button {
			action()
		} label: {
			Image(iconName)
				.resizable()
				.frame(width: size, height: size)
				.padding(4)
		}
		.buttonStyle(BorderlessButtonStyle())
	}
}

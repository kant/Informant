//
//  ComponentsPopover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

// MARK: - Panel Frame

struct ComponentsPanelFrame<Content>: View where Content: View {

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

// MARK: - Panel Blocks

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
				Text(headerSubtitle).H4()
			}

			Spacer()
		}
	}
}

struct ComponentsPanelItemField: View {

	var label: String
	var value: String

	var body: some View {
		VStack(alignment: .leading) {
			// Label
			Text(label).H4()

			// Value
			Text(value).H1()
		}
	}
}

// MARK: - Panel Buttons

struct ComponentsPanelIconButton: View {

	/// The name of the icon in Assets.xcassets
	var iconName: String

	/// Default size is 16.0
	var size: CGFloat
	var width: CGFloat
	var height: CGFloat

	/// Logic for button to execute
	var action: () -> Void

	init(_ iconName: String, size: CGFloat = 16, width: CGFloat? = nil, height: CGFloat? = nil, action: @escaping () -> Void) {
		self.iconName = iconName
		self.size = size
		self.action = action

		// Set width and height, otherwise default to provided inputs
		self.width = size
		self.height = size

		if width != nil {
			self.width = width!
		}

		if height != nil {
			self.height = height!
		}
	}

	var body: some View {
		Button {
			action()
		} label: {
			Image(iconName)
				.resizable()
				.frame(width: width, height: height)
				.padding(5)
		}
		.buttonStyle(BorderlessButtonStyle())
	}
}

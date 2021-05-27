//
//  ComponentsPopover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

// MARK: - Panel Frame

/// Used for large views like single file views.
struct ComponentsPanelFullFrame<Content>: View where Content: View {

	var content: Content

	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content()
	}

	var body: some View {
		VStack(alignment: .leading) {
			content
		}
		.padding(.bottom, 19)
	}
}

/// Used for smaller views like the multi-select or the no file view
struct ComponentsPanelReducedFrame<Content>: View where Content: View {

	var content: Content

	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content()
	}

	var body: some View {
		VStack(alignment: .leading) {
			content
		}
		.frame(height: 50)
	}
}

// MARK: - Panel Blocks

struct ComponentsPanelHeader: View {

	var headerTitle: String
	var headerIcon = NSImage()
	var headerIconCollection: [NSImage] = []
	var headerSubtitle: String

	/// The frame size of the icon. Originally 42.0, now 48.0
	var size: CGFloat = 45

	var body: some View {
		HStack {

			// Single icon present
			if headerIconCollection.count == 0 {
				Image(nsImage: headerIcon).resizable().frame(width: size, height: size)
			}

			// Multiple icons present
			else {
				ComponentsPanelHeaderIconStack(icons: headerIconCollection, size: size)
					.padding([.trailing], 5.5)
			}

			// Header stack
			VStack(alignment: .leading) {
				// Title
				Text(headerTitle).H1()

				Spacer()
					.frame(height: 2)

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
	var lineLimit: Int = 1

	var body: some View {
		VStack(alignment: .leading) {
			// Label
			Text(label).H3()

			Spacer()
				.frame(height: 1)

			// Value
			Text(value).H2()
				.lineLimit(lineLimit)
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

// MARK: - Misc.

struct ComponentsPanelHeaderIconStack: View {

	var icons: [NSImage]
	var size: CGFloat

	var body: some View {
		ZStack {

			// Sixth image, if not nil
			ComponentsPanelHeaderIconInStack(icons: icons, size: size, count: 6, angle: -20, yOffset: -1)

			// Fifth image, if not nil
			ComponentsPanelHeaderIconInStack(icons: icons, size: size, count: 5, angle: 8, xOffset: 2)

			// Fourth image, if not nil
			ComponentsPanelHeaderIconInStack(icons: icons, size: size, count: 4, angle: -5, xOffset: -2, yOffset: -1)

			// Third image, if not nil
			ComponentsPanelHeaderIconInStack(icons: icons, size: size, count: 3, angle: 7, xOffset: 1, yOffset: 2)

			// Second image
			ComponentsPanelHeaderIconInStack(icons: icons, size: size, count: 2, angle: -10)

			// Front first image
			Image(nsImage: icons[0]).resizable().frame(width: size, height: size)
		}
	}
}

struct ComponentsPanelHeaderIconInStack: View {

	var icons: [NSImage]
	var size: CGFloat
	var count: Int
	var angle: Double
	var xOffset: CGFloat = 0
	var yOffset: CGFloat = 0

	var body: some View {
		if icons.count >= count {
			Image(nsImage: icons[count - 1]).resizable().frame(width: size, height: size)
				.rotationEffect(Angle(degrees: angle))
				.offset(x: xOffset, y: yOffset)
		}
	}
}

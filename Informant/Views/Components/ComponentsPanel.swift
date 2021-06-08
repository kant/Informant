//
//  ComponentsPopover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

// MARK: - Panel Frames

/// Used for large views like single file views.
struct ComponentsPanelFullFrame<Content>: View where Content: View {

	var content: Content

	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content()
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			content
		}
		.padding(.bottom, 18)
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
		.frame(height: 52)
	}
}

// MARK: - Panel Blocks

struct ComponentsPanelHeader: View {

	var headerTitle: String?
	var headerIcon: NSImage?
	var headerIconCollection: [NSImage]? = []
	var headerSubtitle: String?

	/// The frame size of the icon. Originally 42.0, now 48.0
	var size: CGFloat = 45

	var body: some View {

		HStack(alignment: .center, spacing: 0) {

			// Single icon present
			if headerIcon != nil, headerIconCollection!.count == 0 {
				Image(nsImage: headerIcon!).resizable().frame(width: size, height: size)
			}

			// Multiple icons present
			else {
				ComponentsPanelHeaderIconStack(icons: headerIconCollection!, size: size)
					.padding([.trailing], 4)
			}

			// Header stack
			if headerTitle != nil, headerSubtitle != nil {
				VStack(alignment: .leading, spacing: 0) {
					// Title
					Text(headerTitle!).H1()

					Spacer()
						.frame(height: 2)

					// Subtitle
					Text(headerSubtitle!).H4()
				}
				.padding(.leading, 7)
			}

			Spacer(minLength: 0)
		}
	}
}

/// Provides the label for the panel item
struct ComponentsPanelItemLabel: View {
	var label: String?
	var body: some View {
		if label != nil {
			Text(label!).H3()
		}

		Spacer()
			.frame(height: 1)
	}
}

/// Provides the unavailable label for a panel item when nil
struct ComponentsPanelItemUnavailable<Content: View>: View {

	let content: Content
	let value: String?
	let lineLimit: Int?

	init(value: String?, lineLimit: Int?, @ViewBuilder content: @escaping () -> Content) {
		self.content = content()
		self.value = value
		self.lineLimit = lineLimit
	}

	var body: some View {
		if value != nil {
			content
		}
		else {
			Text("Unavailable").H2()
				.lineLimit(lineLimit)
				.opacity(Style.Text.darkOpacity)
		}
	}
}

/// The protocol meant to unify different item field types
protocol ComponentsPanelItemProtocol {
	var label: String? { get set }
	var value: String? { get set }
	var lineLimit: Int { get set }
}

/// The standard full panel item → (Size ⮐ 482KB)
struct ComponentsPanelItemField: View, ComponentsPanelItemProtocol {

	var label: String?
	var value: String?
	var lineLimit: Int = 1

	var body: some View {
		VStack(alignment: .leading) {

			// Label
			ComponentsPanelItemLabel(label: label)

			// Value
			ComponentsPanelItemUnavailable(value: value, lineLimit: lineLimit) {
				if value != nil {
					Text(value!).H2()
						.lineLimit(lineLimit)
				}
			}
		}
	}
}

/// The standard full panel item → (Size ⮐ 482KB)
struct ComponentsPanelItemPathField: View, ComponentsPanelItemProtocol {

	var label: String?
	var value: String?
	var lineLimit: Int

	private var doesHaveTilde: Bool = false

	/// Replace the tilde with our own in the case that it does have a tilde
	internal init(label: String?, value: String?, lineLimit: Int = 1) {
		self.label = label
		self.value = value
		self.lineLimit = lineLimit

		#warning("Add in the path switch, to switch between full and truncated path.")
		// Removes tilde in string so we can use a styled one later on
//		var path = self.value
//		if path != nil, path?.first == "~" {
//			path?.removeFirst()
//			self.value = path
//			doesHaveTilde = true
//		}
	}

	var body: some View {
		VStack(alignment: .leading) {

			// Label
			ComponentsPanelItemLabel(label: label)

			// Value
			ComponentsPanelItemUnavailable(value: value, lineLimit: lineLimit) {
				if value != nil {

					#warning("Add in the path switch, to switch between full and truncated path.")
//					// Standard truncated path with tilde
//					if doesHaveTilde {
//						(Text("~").TildeFont().foregroundColor(Color(.displayP3, white: 0.2, opacity: 1.0)) + Text(value!).PathFont())
//							.lineLimit(lineLimit)
//					}
//
//					// Just path
//					else {
//					}

					// Full path no truncation
					HStack(spacing: 0) {
						Text(value!).PathFont()
						Spacer(minLength: 0)
					}
					.fixedSize(horizontal: false, vertical: true)
					.padding(9.0)
					.background(Color.black.opacity(0.05))
					.cornerRadius(6.0)
				}
			}
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

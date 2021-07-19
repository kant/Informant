//
//  ComponentsPopover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import Foundation
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

/// Used for error messages on the panel
struct ComponentsPanelErrorFrame: View {

	let icon: String
	let label: String
	let padding: CGFloat
	let action: (() -> Void)?
	let buttonLabel: String?

	internal init(icon: String, label: String, padding: CGFloat, buttonLabel: String? = nil, action: (() -> Void)? = nil) {
		self.icon = icon
		self.label = label
		self.padding = padding
		self.action = action
		self.buttonLabel = buttonLabel
	}

	var body: some View {

		VStack(alignment: .center, spacing: 6) {

			Text(icon)
				.H1()
				.opacity(Style.Text.opacity)

			Text(label)
				.H1()
				.opacity(Style.Text.opacity)

			// Button
			if let action = action, let buttonLabel = buttonLabel {

				Button {
					action()
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 6.0)
							.opacity(0.1)

						Text(buttonLabel)
							.H3(opacity: 0.85)
							.padding([.vertical], 4)
							.padding([.horizontal], 9)
					}
				}
				.buttonStyle(BorderlessButtonStyle())
			}
		}
		.padding([.vertical], padding)
	}
}

// MARK: - Panel Labels

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
			VStack(alignment: .leading, spacing: 0) {

				// Title
				if let headerTitle = headerTitle {
					Text(headerTitle).PanelTitleFont()
				}

				Spacer()
					.frame(height: 2)

				// Subtitle
				if let headerSubtitle = headerSubtitle {
					Text(headerSubtitle).H4()
				}
			}
			.padding(.leading, 7)

			Spacer(minLength: 0)
		}
	}
}

/// Provides the label for the panel item
struct ComponentsPanelItemLabel: View {

	let icon: String?
	var label: String?
	var opacity: Double

	internal init(icon: String? = nil, label: String?, opacity: Double = Style.Text.opacity) {
		self.icon = icon
		self.label = label
		self.opacity = opacity
	}

	var body: some View {
		if label != nil {
			HStack(spacing: 2.5) {
				Text(label!).H3(opacity: opacity)

				if icon != nil {
					Text(icon!).H3(opacity: opacity)
				}
			}
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

		// Content is being calculated
		if value == SelectionHelper.State.Calculating {
			content
				.lineLimit(lineLimit)
				.opacity(Style.Text.darkOpacity)
		}

		// Or bluntly unavailable
		else if value == SelectionHelper.State.Unavailable {
			content
				.lineLimit(lineLimit)
		}

		// Content is good to go
		else {
			content
		}
	}
}

/// Renders the entire view empty if no data is present
struct ComponentsPanelItemNil<Content: View>: View {

	let content: Content
	let value: String?

	init(value: String?, @ViewBuilder content: @escaping () -> Content) {
		self.content = content()
		self.value = value
	}

	var body: some View {

		if value != nil {
			content
		}

		// If value is nil then render empty
		else {
			EmptyView()
		}
	}
}

/// Creates the path font view for a panel
struct ComponentsPanelPathLabel: View {
	let value: String

	internal init(_ value: String) {
		self.value = value
	}

	var body: some View {
		HStack(spacing: 0) {
			Text(value)
				.PanelPathFont()

			Spacer(minLength: 0)
		}
		.padding(9.0)
	}
}

/// Creates a view that calculates the length of two fields and either stacks them or places them side by side
struct ComponentsPanelItemStack<Content: View>: View {

	let firstValue: String?
	let secondValue: String?

	let firstItem: Content
	let secondItem: Content

	private var isStackTooWide: Bool? = false

	init(firstValue: String?, secondValue: String?, @ViewBuilder firstItem: @escaping () -> Content, @ViewBuilder secondItem: @escaping () -> Content) {

		self.firstValue = firstValue
		self.secondValue = secondValue
		self.firstItem = firstItem()
		self.secondItem = secondItem()

		// Both values are available
		if self.firstValue != nil, self.secondValue != nil {
			// Get the combined length of both items
			let combinedCharCount = self.firstValue!.count + self.secondValue!.count

			// Get width of the window
			let windowWidthAsChars = Int(AppDelegate.current().panel.frame.size.width / 11)

			// Check to see if the combined count of the first item's value & the second item's value exceeds the window width as chars
			if combinedCharCount >= windowWidthAsChars {
				isStackTooWide = true
			}
		}

		// Neither value is available
		else if self.firstValue == nil, self.secondValue == nil {
			isStackTooWide = nil
		}

		// One value is available
		else {
			isStackTooWide = true
		}
	}

	var body: some View {

		// When the stack is too wide the items just get setup in the parenting stack style
		if isStackTooWide == true {
			firstItem
			secondItem
		}

		// Otherwise we can stack both items horizontally
		else if isStackTooWide != nil {
			HStack(spacing: 0) {

				// First item
				firstItem

				// Second item
				secondItem
					.padding([.leading], 15)

				Spacer(minLength: 0)
			}
		}
	}
}

// MARK: - Panel Items

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
	var lineLimit: Int

	internal init(label: String? = nil, value: String? = nil, lineLimit: Int = 1) {
		self.label = label
		self.value = value
		self.lineLimit = lineLimit
	}

	var body: some View {

		ComponentsPanelItemNil(value: value) {

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
}

/// The standard full panel item → (Size ⮐ 482KB)
struct ComponentsPanelItemPathField: View, ComponentsPanelItemProtocol {

	var label: String?
	var value: String?
	var lineLimit: Int

	/// Simplifies keeping track of the settings state
	/* @ObservedObject private var settings: SettingsData */

	/// Replace the tilde with our own in the case that it does have a tilde
	internal init(label: String?, value: String?, lineLimit: Int = 1) {
		self.label = label
		self.value = value
		self.lineLimit = lineLimit
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {

			// ----------- Label -------------
			ComponentsPanelItemLabel(label: label)

			// ------------ Path --------------
			ComponentsPanelItemUnavailable(value: value, lineLimit: lineLimit) {
				if value != nil {

					// Full path, no truncation
					ComponentsPanelPathButton(path: value!)
				}
			}
		}
	}
}

// MARK: - Panel Buttons

/// Basic icon button
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

/// Button icon that reacts with an NSMenuDelegateModified
struct ComponentsPanelIconMenuButton: View {

	/// The name of the icon in Assets.xcassets
	var iconName: String

	/// Default size is 16.0
	var size: CGFloat

	/// Logic for button to execute
	var action: () -> Bool

	init(_ iconName: String, size: CGFloat = 16, action: @escaping () -> Bool) {
		self.iconName = iconName
		self.size = size
		self.action = action
	}

	/// Keeps track of the pressed state of the button
	@State var pressed: Bool = false

	/// Keeps track of the buttons pressed state
	@State var popped: Bool?

	var body: some View {

		Image(iconName)
			.resizable()
			.frame(width: size, height: size)
			.padding(5)
			.opacity(pressed ? 1 : 0.6)
			.inactiveWindowTap { pressed in

				// Makes sure to lock us out in the case that a state is found
				if popped == nil {

					// Only register mouse ups
					if !pressed {
						popped = action()
					}
				}

				// Once another press is made it unlocks
				else if !pressed {
					popped = nil
				}

				self.pressed = pressed
			}

			.whenHovered { hovering in

				// Makes button a normal color when not hovering on it
				if popped == nil, hovering == false, pressed == true {
					pressed = false
				}

				// This makes sure to unlock the toggle above in the case that the user clicks away outside the button
				else if hovering == false, popped != nil {
					popped = nil
				}
			}
	}
}

/// Shows a label on hover behind the content. When clicked an action is performed. Typically this is used with text objects.
struct ComponentsPanelLabelButton<Content: View>: View {

	let content: Content
	var action: () -> Void

	@State private var isHovering: Bool = false

	internal init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
		self.content = content()
		self.action = action
	}

	var body: some View {
		Button {
			withAnimation(.easeInOut(duration: 0.1)) {
				action()
			}
		} label: {
			ZStack(alignment: .leading) {

				// Backing
				Color(.displayP3, white: 0.75, opacity: 0.2)
					.cornerRadius(5.0)
					.opacity(isHovering ? 1 : 0)
					.animation(.easeInOut(duration: 0.2))

				// Label
				content
					.padding(4.0)
					.frame(maxWidth: .infinity)
					.fixedSize(horizontal: true, vertical: false)
			}
		}
		.offset(x: -3.0, y: 0)
		.buttonStyle(BorderlessButtonStyle())
		.whenHovered { hovering in
			isHovering = hovering
		}
	}
}

/// The hover pad button used for path and where fields
struct ComponentsPanelPathButton: View {

	let path: String

	/// Keeps track of the panel's hovering
	@State private var hovering: Bool = false

	// Gradient stops
	let firstStop = Gradient.Stop(color: .primary, location: 0.4)
	let secondStop = Gradient.Stop(color: .clear, location: 0.73)

	var body: some View {

		ZStack {
			// Backing
			Color.primary
				.opacity(hovering ? 0.1 : 0.04)

			// Icon
			HStack {
				Spacer()
				VStack(alignment: .trailing, spacing: nil) {

					Text(ContentManager.Icons.panelCopyIcon)
						.PanelPadIconFont()
						.opacity(hovering ? 0.3 : 0)
						.padding(8.0)

					Spacer(minLength: 0)
				}
			}

			// Gradiented text
			LinearGradient(gradient: .init(stops: [firstStop, secondStop]), startPoint: .bottom, endPoint: .topTrailing)
				.mask(ComponentsPanelPathLabel(path))
				.opacity(hovering ? 1 : 0)

			// Non-gradiented text
			ComponentsPanelPathLabel(path)
				.opacity(hovering ? 0 : 1)
		}
		.fixedSize(horizontal: false, vertical: true)
		.animation(.easeInOut(duration: 0.16), value: hovering)
		.cornerRadius(7.0)
		.padding([.top], 2.0)

		// When hovering logic
		.whenHovered { hovering in
			self.hovering = hovering
		}
		// When pressed logic
		.inactiveWindowTap { pressed in
			if pressed {
				AppDelegate.current().interfaceAlertController?.showCopyAlertForPath(path)
			}
		}
	}
}

// MARK: - Panel Icons

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

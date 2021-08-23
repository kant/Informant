//
//  ComponentsWindow.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-17.
//

import SwiftUI

/// Just an image of the app icon
struct ComponentsWindowAppIcon: View {
	var body: some View {
		Image(nsImage: NSImage(named: ContentManager.Images.appIcon) ?? NSImage())
			.resizable()
			.frame(width: Style.Icons.appIconSize, height: Style.Icons.appIconSize, alignment: .center)
	}
}

/// This is just a toggle with some padding between the toggle and title.
struct TogglePadded: View {

	let title: String
	var binding: Binding<Bool>

	internal init(_ title: String, isOn: Binding<Bool>) {
		self.title = title
		self.binding = isOn
	}

	var body: some View {
		Toggle(isOn: binding) {
			Text(title).togglePadding()
		}
	}
}

extension Text {

	/// Adds some extra padding at the end
	func togglePadding() -> some View {
		self.padding([.leading], 4)
	}
}

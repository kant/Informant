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

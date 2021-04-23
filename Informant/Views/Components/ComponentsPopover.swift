//
//  ComponentsPopover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

// MARK: - Header

struct ComponentsPopoverHeader: View {

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

// MARK: - File Attribute
struct ComponentsPopoverFileAttribute: View {

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

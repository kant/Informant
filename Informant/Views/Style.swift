//
//  Styling.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Contains all styling constants to be used across app
class Style {
	public enum Text {
		static let opacity = 0.5
		static let font = "SF Compact Display"
	}
}

extension Text {
	func H1() -> some View {
		self.font(.system(size: 17))
			.fontWeight(.regular)
			.lineLimit(1)
	}

	func H2() -> Text {
		self.font(.system(size: 17))
			.kerning(-0.1)
			.fontWeight(.regular)
	}

	func H2Compact() -> Text {
		self.font(.custom(Style.Text.font, size: 18))
	}

	func H3() -> some View {
		self.font(.system(size: 11))
			.fontWeight(.medium)
			.opacity(Style.Text.opacity)
			.lineLimit(1)
	}

	func H4() -> some View {
		self.font(.system(size: 11))
			.fontWeight(.medium)
			.kerning(-0.25)
			.lineLimit(1)
			.opacity(Style.Text.opacity)
	}
}

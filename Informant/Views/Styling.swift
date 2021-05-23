//
//  Styling.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

extension Text {
	func H1() -> some View {
		self.font(.system(size: 17))
			.fontWeight(.regular)
			.lineLimit(1)
	}

	func H2() -> some View {
		self.font(.system(size: 15))
			.fontWeight(.regular)
			.lineLimit(1)
	}

	func H4() -> some View {
		self.font(.system(size: 11))
			.fontWeight(.medium)
			.opacity(0.5)
	}
}

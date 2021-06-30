//
//  PanelTags.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-29.
//

import SwiftUI
import WrappingHStack

struct ComponentsPanelTags: View {

	var tags: SelectionTags?

	internal init(tags: SelectionTags? = nil) {
		self.tags = tags
	}

	var body: some View {
		if let tags = tags {
			WrappingHStack(tags.colourTags, id: \.self, spacing: .constant(5)) { tag in
				Tag(label: tag.label, color: tag.color)
			}
		}
	}
}

/// A single tag
struct Tag: View {

	var label: String
	var color: Color?

	private let circleSize: CGFloat = 10

	var body: some View {
		HStack(spacing: 0) {

			// Only present if a colour is available
			if let color = color {
				Circle()
					.fill(color)

					// Stroke
					.overlay(
						Circle()
							.stroke(lineWidth: 1)
							.fill(Color.primary)
							.opacity(color == .clear ? 0.5 : 0.1)
					)

					// Diameter
					.frame(width: circleSize, height: circleSize)

					// Makes sure tag is padded when colour is present
					.padding([.trailing], 6)
			}

			Text(label)
				.PanelTagFont()
		}
		.fixedSize()

		// Interior padding
		.padding(2)

		// Lateral padding
		.padding([.horizontal], 5)

		.background(
			RoundedRectangle(cornerRadius: 5)
				.fill(Color.secondary)
				.opacity(0.1)
		)

		// Total opacity
		.opacity(0.9)

		// Exterior padding
		.padding([.top], 5)
	}
}

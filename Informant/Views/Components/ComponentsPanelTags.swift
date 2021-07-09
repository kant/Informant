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

			// Full tag stack
			VStack(alignment: .leading) {

				// Label
				ComponentsPanelItemLabel(label: "Tags")

				// All tags
				WrappingHStack(tags.colourTags, id: \.self, alignment: .leading, spacing: .constant(5)) { tag in
					Tag(label: tag.label, color: tag.color)
				}
			}

			// Pulls the view down effectively removing padding from the bottom of each tag on the bottom row
			.padding([.bottom], -5)
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

		// Lateral padding
		.padding([.trailing], 5)

		// Exterior padding
		.padding([.vertical], 4.5)

		// Total opacity
		.opacity(0.9)
	}
}

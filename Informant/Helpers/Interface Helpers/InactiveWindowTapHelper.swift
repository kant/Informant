//
//  NonKeyTapHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-14.
//

import Foundation
import SwiftUI

extension View {
	func inactiveWindowTap(_ pressed: @escaping (Bool) -> Void) -> some View {
		modifier(InactiveWindowTapModifier(pressed))
	}
}

struct InactiveWindowTapModifier: ViewModifier {
	let pressed: (Bool) -> Void

	init(_ pressed: @escaping (Bool) -> Void) {
		self.pressed = pressed
	}

	func body(content: Content) -> some View {
		content.overlay(
			GeometryReader { proxy in
				ClickableViewRepresentable(
					pressed: pressed,
					frame: proxy.frame(in: .global)
				)
			}
		)
	}
}

private struct ClickableViewRepresentable: NSViewRepresentable {
	let pressed: (Bool) -> Void
	let frame: NSRect

	func updateNSView(_ nsView: ClickableView, context: Context) {
		nsView.pressed = pressed
	}

	func makeNSView(context: Context) -> ClickableView {
		ClickableView(frame: frame, pressed: pressed)
	}
}

class ClickableView: NSView {

	public var pressed: ((Bool) -> Void)?

	private var dragged: Bool?

	init(frame: NSRect, pressed: ((Bool) -> Void)?) {
		super.init(frame: frame)
		self.pressed = pressed
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
		return true
	}

	override func mouseDown(with event: NSEvent) {
		if dragged == false {
			pressed?(true)
		} else {
			dragged = false
		}
	}

	override func mouseUp(with event: NSEvent) {
		if dragged == false {
			pressed?(false)
		} else {
			dragged = false
		}
	}

	// Makes sure to cancel out taps when dragging
	override func mouseDragged(with event: NSEvent) {
		dragged = true
	}
}

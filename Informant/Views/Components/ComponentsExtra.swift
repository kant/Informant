//
//  ComponentsExtra.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-15.
//

import SwiftUI

// MARK: - Visual Effects

/// Creates a blurred background effect for the main interface. Allows it to be called in SWiftUI.
struct VisualEffectView: NSViewRepresentable {
	let material: NSVisualEffectView.Material
	let blendingMode: NSVisualEffectView.BlendingMode
	let emphasized: Bool

	func makeNSView(context: Context) -> NSVisualEffectView {
		let visualEffectView = NSVisualEffectView()
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.material = material
		visualEffectView.state = NSVisualEffectView.State.active
		visualEffectView.blendingMode = blendingMode
		visualEffectView.isEmphasized = emphasized

		return visualEffectView
	}

	func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
		visualEffectView.material = material
		visualEffectView.blendingMode = blendingMode
		visualEffectView.isEmphasized = emphasized
	}
}

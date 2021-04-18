//
//  Shortcuts.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation
import KeyboardShortcuts

// MARK: - Keyboard Shortcuts Package
/// This is an open source package to make global shortcuts easier.
/// https://github.com/sindresorhus/KeyboardShortcuts

// Declare shortcut names in here with the static tag. These shortcuts are then available globally.
extension KeyboardShortcuts.Name {
	static let togglePopover = Self("togglePopover")
}

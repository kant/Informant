//
//  PasteboardHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-15.
//

import Foundation
import SwiftUI

/// Contains functionallity related to the system's pasteboard
class PasteboardHelper {

	/// Copies the data to the pasteboard
	static func copyToPasteboard(_ string: String, type: NSPasteboard.PasteboardType) {
		let pasteboard = NSPasteboard.general
		pasteboard.declareTypes([type], owner: nil)
		pasteboard.setString(string, forType: type)
	}

	/// Copies a path specifically to the pasteboard
	static func copyPathToPasteboard(_ path: String) {
		copyToPasteboard(formatPathForEscapes(path), type: .string)
	}

	/// Formats a path string for special characters
	static func formatPathForEscapes(_ originalString: String) -> String {

		var string = originalString
		var escapes = 0

		// Cycle through characters and place escapes
		for (index, char) in originalString.enumerated() {
			if char.isSymbol || char.isWhitespace || char == "&" {
				string.insert("\\", at: string.index(string.startIndex, offsetBy: index + escapes))
				escapes += 1
			}
		}

		// Remove tilde escape from start
		if string.first == "\\" {
			string.removeFirst()
		}

		return string
	}
}

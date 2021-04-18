//
//  AppleScripts.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation

// MARK: - Apple Scripts
/// Used to store and use any apple scripts

class AppleScripts {

	// Find the currently selected Finder files in a string format with line breaks.
	public static func findSelectedFiles() -> [String] {

		// Find selected items as a list with line breaks
		var errorInformation: NSDictionary?
		let script = NSAppleScript(source: """
			set AppleScript's text item delimiters to linefeed
			tell application "Finder"
			return selection as text
			end tell
		""")

		// Check for errors before using
		guard let scriptExecuted = script?.executeAndReturnError(&errorInformation) else {
			if errorInformation != nil { print(errorInformation!) }
			return [""]
		}

		// Parse list for colons and replace with slashes
		let selectedItems = scriptExecuted.stringValue!
		let selectedItemsParsed = selectedItems.replacingOccurrences(of: ":", with: "/")

		// Convert list with line breaks to string array
		var selectedItemsAsArray = selectedItemsParsed.components(separatedBy: .newlines)

		// Find pure path from each string
		for (index, var url) in selectedItemsAsArray.enumerated() {
			let startIndex = url.startIndex
			let slashIndex = url.firstIndex(of: "/")
			let endIndex = url.index(slashIndex!, offsetBy: -1)

			url.removeSubrange(startIndex ... endIndex)
			selectedItemsAsArray[index] = url
		}

		return selectedItemsAsArray
	}
}

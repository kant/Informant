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

		/// Apple script that tells Finder to give us the file paths
		let script = NSAppleScript(source: """
			set pathArray to {}
			tell application "Finder"

				set sel to selection

				repeat with j from 1 to count sel
					set selRecord to POSIX path of ((item j of sel) as string)
					copy selRecord to end of pathArray
				end repeat

				return pathArray

			end tell
		""")

		// Check for errors before using
		guard let scriptExecuted = script?.executeAndReturnError(&errorInformation) else {
			if errorInformation != nil { print(errorInformation!) }
			return [""]
		}

		// Parse list for colons and replace with slashes
		guard let selectedItems = scriptExecuted.stringValue else {
			return [""]
		}

		// Replaces all colons to turn it into a POSIX path
		let selectedItemsParsed = selectedItems.replacingOccurrences(of: ":", with: "/")

		// Convert list with line breaks to string array
		let selectedItemsAsArray = selectedItemsParsed.components(separatedBy: .newlines)

		return selectedItemsAsArray
	}
}

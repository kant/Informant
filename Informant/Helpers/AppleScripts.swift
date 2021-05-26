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
			set AppleScript's text item delimiters to linefeed
			  tell application "Finder"
				  set fSelection to selection as text
				  log fSelection
			  return fSelection
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

		// Convert list with line breaks to string array
		var selectedItemsAsArray = selectedItems.components(separatedBy: .newlines)

		// Cycle through selected items and convert each one from an HFS path to a POSIX path
		for (index, path) in selectedItemsAsArray.enumerated() {
			selectedItemsAsArray[index] = path.posixPathFromHFSPath()!
		}

		return selectedItemsAsArray
	}
}

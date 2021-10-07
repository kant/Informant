//
//  AppleScripts.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation

// MARK: - Apple Scripts
/// Used to store and use any apple scripts

class AppleScriptsHelper {

	// Find the currently selected Finder files in a string format with line breaks.
	public static func findSelectedFiles() -> AppleScriptOutput? {

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

			// If error is present then let the user know that we're unable to get the selection
			if errorInformation != nil {
				return AppleScriptOutput(paths: nil, error: true)
			}

			return nil
		}

		// Parse list for colons and replace with slashes
		guard let selectedItems = scriptExecuted.stringValue else {
			return nil
		}

		// Convert list with line breaks to string array
		var selectedItemsAsArray = selectedItems.components(separatedBy: .newlines)

		// Check for an empty selection
		if selectedItemsAsArray[0].isEmpty {
			return nil
		}

		// Cycle through selected items and convert each one from an HFS path to a POSIX path
		for (index, path) in selectedItemsAsArray.enumerated() {

			guard let pathAsPOSIX = path.posixPathFromHFSPath() else {
				return nil
			}
			selectedItemsAsArray[index] = pathAsPOSIX
		}

		return AppleScriptOutput(paths: selectedItemsAsArray, error: nil)
	}
}

/// This is just an object that allows us to send error information along with the urls
class AppleScriptOutput {
	var paths: [String]?
	var error: Bool?

	internal init(paths: [String]?, error: Bool?) {
		self.paths = paths
		self.error = error
	}
}

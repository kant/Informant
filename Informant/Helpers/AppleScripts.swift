//
//  AppleScripts.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation

// MARK: - Apple Scripts

class AppleScripts {

	// Find the currently selected Finder files in a string format with line breaks.
	func findSelectedFiles() -> String {
		// Reference AppleScript and prep error information object
		var errorInformation: NSDictionary?
		let script = NSAppleScript(source: "tell application \"Finder\" to return selection as text")

		// Unwrap optional conditionally and return value
		guard let scriptExecuted = script?.executeAndReturnError(&errorInformation) else {
			if errorInformation != nil { print(errorInformation!) }
			return ""
		}
		return scriptExecuted.stringValue!
	}
}

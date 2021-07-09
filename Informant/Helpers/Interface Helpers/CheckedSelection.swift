//
//  CheckedSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-07-08.
//

import Foundation

class CheckedSelection {

	var selection: AppleScriptOutput
	var state: State

	enum State {
		case errorSelection
		case uniqueSelection
		case duplicateSelection
	}

	init(_ selection: AppleScriptOutput, state: CheckedSelection.State) {
		self.selection = selection
		self.state = state
	}
}

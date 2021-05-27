//
//  InterfaceData.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import Foundation

class InterfaceData {
	var fileCollection: ItemCollection?

	/// Checks to make sure that all data is valid
	public var isNotNil: Bool {
		if fileCollection == nil || fileCollection!.selectItem.title == nil {
			return false
		} else {
			return true
		}
	}
}

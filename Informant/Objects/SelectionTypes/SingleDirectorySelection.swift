//
//  SingleDirectorySelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleDirectorySelection: SingleSelection {
	required init(_ urls: [String], selection: SelectionType = .Directory) {
		super.init(urls, selection: selection)
	}
}

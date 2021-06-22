//
//  SingleApplicationSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleApplicationSelection: SingleSelection {
	required init(_ urls: [String], selection: SelectionType = .Application) {
		super.init(urls, selection: selection)
	}
}

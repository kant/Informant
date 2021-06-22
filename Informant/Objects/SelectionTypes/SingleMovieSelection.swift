//
//  SingleMovieSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleMovieSelection: SingleSelection {
	required init(_ urls: [String], selection: SelectionType = .Movie) {
		super.init(urls, selection: selection)
	}
}

//
//  SingleAudioSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleAudioSelection: SingleSelection {
	required init(_ urls: [String], selection: SelectionType = .Audio) {
		super.init(urls, selection: selection)
	}
}

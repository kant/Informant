//
//  SelectionProtocol.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-01.
//

import Foundation

protocol SelectItemProtocol {

	var selection: Selection { get set }

	init(_ urls: [String], _ selectedItems: Selection)
}

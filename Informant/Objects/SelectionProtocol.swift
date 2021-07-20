//
//  SelectionProtocol.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-01.
//

import Foundation

protocol SelectionProtocol: SelectionHelper {

	/// Defines the selection type used. Must not be nil!
	var selectionType: SelectionType { get set }

	/// Contains all resources for the file
	var itemResources: URLResourceValues? { get set }

	/// The title the interface displays
	var itemTitle: String? { get set }

	/// The size of the item as a string
	var itemSizeAsString: String? { get set }

	init(_ urls: [String], selection: SelectionType)
}

//
//  SelectionProtocol.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-01.
//

import Foundation

protocol SelectionProtocol {

	/// Defines the selection type used. Must not be nil!
	var collectionType: Selection.CollectionType? { get set }

	/// Contains all resources for the file
	var fileResources: URLResourceValues? { get set }

	/// The title the interface displays
	var title: String? { get set }

	/// The size the interface displays
	var size: Int? { get set }

	init?(_ urls: [String])
}

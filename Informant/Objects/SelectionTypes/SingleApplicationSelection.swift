//
//  SingleApplicationSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-21.
//

import Foundation

class SingleApplicationSelection: SingleSelection {

	var version: String?

	required init(_ urls: [String], selection: SelectionType = .Application, parameters: [SelectionParameters] = [.grabSize]) {

		// Get basic selection
		super.init(urls, selection: selection, parameters: parameters)

		// Metadata keys we want
		let keys: NSArray = [
			kMDItemVersion!
		]

		// Get metadata
		guard let metadata = SelectionHelper.getURLMetadata(url, keys: keys) else { return }

		// Get version #
		guard let version = metadata[kMDItemVersion] else { return }
		self.version = String(describing: version)
	}
}

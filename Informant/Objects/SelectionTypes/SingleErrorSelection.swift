//
//  SingleErrorSelection.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-28.
//

import Foundation

class SingleErrorSelection: SelectionHelper, SelectionProtocol {
	
	var selectionType: SelectionType
	
	var itemResources: URLResourceValues?
	
	var itemTitle: String?
	
	var itemSize: Int?
	
	var itemSizeAsString: String?
	
	var workQueue: [DispatchWorkItem] = []
	
	required init(_ urls: [String] = [], selection: SelectionType = .Error, parameters: [SelectionParameters] = [.grabSize]) {
		
		selectionType = selection
		
		super.init()
	}
}

//
//  PopoverMultiFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverMultiFile: View {

	var selection: SelectItem

	var body: some View {

		ComponentsPanelFrame {

			// Establish title
			ComponentsPanelHeader(
				headerIconCollection: selection.totalIcons,
				headerTitle: selection.title!,
				headerSubtitle: selection.sizeAsString!
			)
		}
	}
}

//
//  PopoverMultiFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Shown when multiple files are selected by the user.
struct PopoverMultiFile: View {

	var selection: SelectItem

	var body: some View {
		ComponentsPanelReducedFrame {

			// Main header
			ComponentsPanelHeader(
				headerTitle: selection.title!,
				headerIconCollection: selection.totalIcons,
				headerSubtitle: selection.sizeAsString!
			)
		}
	}
}

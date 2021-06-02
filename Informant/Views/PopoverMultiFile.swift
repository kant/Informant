//
//  PopoverMultiFile.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Shown when multiple files are selected by the user.
struct PopoverMultiFile: View {

	var selection: Selection

	var body: some View {
		ComponentsPanelReducedFrame {
			ComponentsPanelHeader(
				headerTitle: selection.title!,
				headerIconCollection: selection.totalIcons,
				headerSubtitle: selection.fileSizeAsString!
			)
		}
	}
}

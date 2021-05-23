//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverSingleFile: View {

	var file: SelectItem

	var body: some View {

		ComponentsPanelFrame {

			ComponentsPanelHeader(
				headerIcon: file.fileTypeIcon!,
				headerTitle: file.fileName!,
				headerSubtitle: file.fileDateModifiedAsString!
			)

			Divider().padding(.bottom, 10)

			VStack(alignment: .leading, spacing: 20) {
				// Kind - Size
				HStack {
					ComponentsPanelItemField(label: "Kind", value: String(file.fileKind!))
					ComponentsPanelItemField(label: "Size", value: String(file.fileSizeAsString!))
				}

				// Created
				ComponentsPanelItemField(label: "Created", value: file.fileDateCreatedAsString!)

				// Path
				ComponentsPanelItemField(label: "Path", value: file.filePath!)
			}
		}
	}
}

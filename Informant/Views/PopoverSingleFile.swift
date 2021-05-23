//
//  Popover.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

struct PopoverSingleFile: View {

	var file: SelectItem

//	init() {
//		file = interfaceData!.fileCollection!.files[0]
//	}

	var body: some View {

		ComponentsPanelFull {

			ComponentsPanelHeader(
				headerIcon: file.fileTypeIcon!,
				headerTitle: file.fileName!,
				headerSubtitle: file.fileDateModifiedAsString!
			)

			Divider().padding(.bottom, 10)

			VStack(alignment: .leading, spacing: 20) {
				// Kind - Size
				HStack {
					ComponentsPanelItemAttribute(label: "Kind", value: String(file.fileKind!))
					ComponentsPanelItemAttribute(label: "Size", value: String(file.fileSizeAsString!))
				}

				// Created
				ComponentsPanelItemAttribute(label: "Created", value: file.fileDateCreatedAsString!)

				// Path
				ComponentsPanelItemAttribute(label: "Path", value: file.filePath!)
			}
		}
	}
}

//
//  AppDelegate.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Cocoa
import FinderSync
import KeyboardShortcuts
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	// Creates var for the status bar controller and popover
	var popover = NSPopover()
	var statusBar: StatusBarController?

	func applicationDidFinishLaunching(_: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()

		// Set the SwiftUI view to the popover view
		popover.contentSize = NSSize(width: 360, height: 360)
		popover.contentViewController = NSHostingController(rootView: contentView)

		// Initialize status bar
		statusBar = StatusBarController(popover)

		// Keyboard shortcuts
		KeyboardShortcuts.onKeyUp(for: .togglePopover) { [self] in
//			statusBar?.togglePopover(sender: popover)
			findFinderItems()
		}
	}

	func findFinderItems() {
		let selectedItems = AppleScripts().findSelectedFiles()

		print(findURL(url: selectedItems[0]))
		print(selectedItems)
	}

	func findURL(url: String) -> UInt64 {
		let filePath = url
		var fileSize: UInt64

		do {
			// return [FileAttributeKey : Any]
			let attr = try FileManager.default.attributesOfItem(atPath: filePath)
			fileSize = attr[FileAttributeKey.size] as! UInt64

			// if you convert to NSDictionary, you can get file size old way as well.
			let dict = attr as NSDictionary
			fileSize = dict.fileSize()

			return fileSize
		} catch {
			print("Error: \(error)")
		}

		return 0
	}

	func applicationWillTerminate(_: Notification) {
		// Insert code here to tear down your application
	}
}

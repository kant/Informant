//
//  SecurityBookmarkHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import Foundation
import SwiftUI

class SecurityBookmarkHelper {

	let openPanel = NSOpenPanel()

	var rootURL: URL? {
		willSet(value) {
			AppDelegate.current().interfaceState.settingsRootURL = value?.path
		}
	}

	init() {
		openPanel.allowsMultipleSelection = false
		openPanel.canChooseDirectories = true
		openPanel.canChooseFiles = false
		openPanel.showsHiddenFiles = false

		openPanel.prompt = ContentManager.Titles.openPanelGrantAccess
		openPanel.directoryURL = URL(fileURLWithPath: "/")
	}

	// DEPRECATED
	/// Requests the root url through an NSOpenPanel
	/*
	 func requestRootURLPermission() {
	 	if isAccessToRootURLStale() == true {
	 		pickRootURL()
	 	}
	 }
	 */

	/// Opens the NSOpenPanel to store a new root url
	func pickRootURL(_ windowRef: NSWindow) {
		openPanel.beginSheetModal(for: windowRef) { response in
			if response == .OK, let url = self.openPanel.url {
				self.storeRootURLPermission(url)
				self.closePanel()
			} else {
				self.closePanel()
			}
		}
	}

	/// Simple closer for the panel
	func closePanel() {
		openPanel.close()
		openPanel.setFrame(NSRect(x: 0, y: 0, width: 500, height: 400), display: false)
	}

	/// Stores the provided security scoped url into user defaults
	func storeRootURLPermission(_ url: URL) {
		do {
			rootURL = url
			let bookmark = try url.bookmarkData(options: .securityScopeAllowOnlyReadAccess, includingResourceValuesForKeys: nil, relativeTo: nil)
			UserDefaults.standard.set(bookmark, forKey: .keyRootURLBookmarkData)
		} catch {}
	}

	/// Remove security scoped url from user defaults
	func deleteRootURLPermission() {
		rootURL = nil
		UserDefaults.standard.removeObject(forKey: .keyRootURLBookmarkData)
	}

	/// Retrieves the security scoped url from user defaults
	func getRootURLPermission() -> Data? {
		return UserDefaults.standard.object(forKey: .keyRootURLBookmarkData) as? Data
	}

	/// Begins access to the securiy scoped url
	func startAccessingRootURL() -> Bool? {
		var isStale: Bool = false
		if let bookmarkData = getRootURLPermission() {
			do {
				rootURL = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
				let result = rootURL!.startAccessingSecurityScopedResource()
				return result
			} catch { }
		}

		return nil
	}

	/// Stop access to the security scoped url
	func stopAccessingRootURL() {
		rootURL?.stopAccessingSecurityScopedResource()
	}

	/// Returns the root url stored in user defaults
	func getRootURL() -> URL? {
		var isStale: Bool = false
		if let bookmarkData = getRootURLPermission() {
			do {
				rootURL = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
				return rootURL
			} catch { }
		}

		return nil
	}

	/// Checks if access to the security scoped url is still valid
	func isAccessToRootURLStale() -> Bool {
		var isStale: Bool = false
		if let bookmarkData = getRootURLPermission() {
			do {
				rootURL = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
				return isStale
			} catch { }
		}

		return true
	}
}

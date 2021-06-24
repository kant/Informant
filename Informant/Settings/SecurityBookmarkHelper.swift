//
//  SecurityBookmarkHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-22.
//

import Foundation
import SwiftUI

class SecurityBookmarkHelper {

	let panel = NSOpenPanel()

	var rootURL: URL?

	init() {
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = true
		panel.canChooseFiles = false
		panel.prompt = "Grant Access"
	}

	/// Requests the root url through an NSOpenPanel
	func requestRootURLPermission() {
		if isAccessToRootURLStale() == true {
			panel.beginSheetModal(for: AppDelegate.current().window) { response in
				if response == .OK, let url = self.panel.url {
					self.storeRootURLPermission(url)
				}

				self.panel.close()
			}
		}
	}

	/// Stores the provided security scoped url into user defaults
	func storeRootURLPermission(_ url: URL) {
		do {
			let bookmark = try url.bookmarkData(options: .securityScopeAllowOnlyReadAccess, includingResourceValuesForKeys: nil, relativeTo: nil)
			UserDefaults.standard.set(bookmark, forKey: UserDefaults.Keys.RootURL)
		} catch {}
	}

	/// Remove security scoped url from user defaults
	func deleteRootURLPermission() {
		UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.RootURL)
	}

	/// Retrieves the security scoped url from user defaults
	func getRootURLPermission() -> Data? {
		return UserDefaults.standard.object(forKey: UserDefaults.Keys.RootURL) as? Data
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

//
//  DispatchQueueHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-25.
//

import Foundation

/// Stores each url's byte size at a specific time stamp
class Cache {
	private var directorySizeCache: [URL: DirectorySize] = [:]

	/// Stores the provided bytes into the cache at the position of the url using it as the key
	func storeByteSizeInCache(_ url: URL, _ bytes: Int64, _ type: SelectionHelper.SelectionType) {
		directorySizeCache[url] = DirectorySize(bytes: bytes, type: type)
	}

	/// Retrieves the byte size from the cache
	func getByteSizeInCache(_ url: URL, _ type: SelectionHelper.SelectionType) -> DirectorySize? {

		// Gets the object out of the cache
		guard let directorySize = directorySizeCache[url] else {
			return nil
		}

		// Checks to make sure it's not expired before returning
		if directorySize.isExpired() {
			return nil
		}

		return directorySize
	}
}

class DirectorySize {

	var expiry: TimeInterval
	var bytes: Int64

	internal init(bytes: Int64, type: SelectionHelper.SelectionType) {
		self.bytes = bytes

		// Get timestamp created
		let created = Date().timeIntervalSince1970
		var interval: TimeInterval = 0

		// Find expiry by adding specified time to created time
		switch type {

		// Expiry is 10 minutes for applications
		case .Application: interval = (60 * 10)
			break

		// Expiry is 10 seconds for directories
		case .Directory: interval = 10
			break

		default:
			break
		}

		// Set final expiry
		expiry = created + interval
	}

	/// Checks if the object is valid
	func isExpired() -> Bool {

		// Get the current timestamp
		let now = Date().timeIntervalSince1970

		// Compare it to the old timestamp
		if now >= expiry {
			return true
		}

		return false
	}
}

extension URL {
	/// Stores the given byte size into the cache
	func storeByteSize(_ bytes: Int64, _ type: SelectionHelper.SelectionType) {
		AppDelegate.current().cache.storeByteSizeInCache(self, bytes, type)
	}

	/// Retrieves the byte size from the cache
	func getCachedByteSize(_ type: SelectionHelper.SelectionType) -> Int64? {
		return AppDelegate.current().cache.getByteSizeInCache(self, type)?.bytes
	}
}


//
//  Copyright (c) 2016, 2018 Nikolai Ruhe. All rights reserved.
//

import Foundation

public extension FileManager {

	/// Calculate the allocated size of a directory and all its contents on the volume.
	///
	/// As there's no simple way to get this information from the file system the method
	/// has to crawl the entire hierarchy, accumulating the overall sum on the way.
	/// The resulting value is roughly equivalent with the amount of bytes
	/// that would become available on the volume if the directory would be deleted.
	///
	/// - note: There are a couple of oddities that are not taken into account (like symbolic links, meta data of
	/// directories, hard links, ...).
	func allocatedSizeOfDirectory(at directoryURL: URL) throws -> Int64 {

		// The error handler simply stores the error and stops traversal
		var enumeratorError: Error?
		func errorHandler(_: URL, error: Error) -> Bool {
			enumeratorError = error
			return false
		}

		// We have to enumerate all directory contents, including subdirectories.
		let enumerator = self.enumerator(
			at: directoryURL,
			includingPropertiesForKeys: Array(allocatedSizeResourceKeys),
			options: [],
			errorHandler: errorHandler
		)!

		// We'll sum up content size here:
		var accumulatedSize: Int64 = 0

		// Perform the traversal.
		for item in enumerator {

			// Bail out on errors from the errorHandler.
			if enumeratorError != nil { break }

			// Add up individual file sizes.
			let contentItemURL = item as! URL
			accumulatedSize += try contentItemURL.regularFileAllocatedSize()
		}

		// Rethrow errors from errorHandler.
		if let error = enumeratorError { throw error }

		return accumulatedSize
	}

	/// Finds the total number of items in the directory, including all items contained within sub-directories.
	func countOfItemsInDirectory(at directoryURL: URL) -> Int? {

		// The error handler simply stores the error and stops traversal
		var enumeratorError: Error?
		func errorHandler(_: URL, error: Error) -> Bool {
			enumeratorError = error
			return false
		}

		// Enumerate through all of the directory's contents
		guard let enumerator = self.enumerator(
			at: directoryURL,
			includingPropertiesForKeys: [],
			options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles, .skipsPackageDescendants],
			errorHandler: errorHandler
		) else { return nil }

		/// Total item count in directory
		var itemCount = 0

		// Perform the calculation
		for _ in enumerator {

			// Bail out on errors from the error handler
			if enumeratorError != nil { break }

			itemCount += 1
		}

		return itemCount
	}
}

private extension URL {

	func regularFileAllocatedSize() throws -> Int64 {
		let resourceValues = try self.resourceValues(forKeys: allocatedSizeResourceKeys)

		// To get the file's size we first try the most comprehensive value in terms of what
		// the file may use on disk. This includes metadata, compression (on file system
		// level) and block size.

		// In case totalFileAllocatedSize is unavailable we use the fallback value (excluding
		// meta data and compression) This value should always be available.

		return Int64(resourceValues.totalFileSize ?? 0)
	}
}

private let allocatedSizeResourceKeys: Set<URLResourceKey> = [
	.totalFileSizeKey
]

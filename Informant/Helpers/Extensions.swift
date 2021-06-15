//
//  Extensions.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation
import SwiftUI

// MARK: - Extensions
// Use this file for storing any sort of extensions to classes.

// MARK: - Strings

extension String {
	/// Provides the number of words of a string as an integer.
	var numberOfWords: Int {
		var count = 0
		let range = startIndex ..< endIndex
		enumerateSubstrings(in: range, options: [.byWords, .substringNotRequired, .localized]) { _, _, _, _ -> Void in
			count += 1
		}
		return count
	}
}

extension String {
	/// Capitalize each word without replacing an already all caps word. So instead of HTML -> Html it goes HTML -> HTML.
	var capitalizeEachWord: String {
		// break it into an array by delimiting the sentence using a space
		let breakupSentence = components(separatedBy: " ")
		var newSentence = ""

		// Loop the array and split each word from it's first letter. Capitalize the first letter and then
		// concaitenate
		for wordInSentence in breakupSentence {
			let firstLetter = wordInSentence.first!.uppercased()
			let remainingWord = wordInSentence.suffix(wordInSentence.count - 1)
			newSentence = "\(newSentence) \(firstLetter)\(remainingWord)"
		}

		// Remove space at beginning
		newSentence.removeFirst()

		// send it back up.
		return newSentence
	}
}

// Translates HFS path to POSIX path
extension String {
	/// Translates HFS path to POSIX path.
	/// [Check this out for more info](https://en.wikibooks.org/wiki/AppleScript_Programming/Aliases_and_paths).
	func posixPathFromHFSPath() -> String? {
		guard let fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, self as CFString?, CFURLPathStyle(rawValue: 1)!, hasSuffix(":")) else {
			return nil
		}
		return (fileURL as URL).path
	}
}

// MARK: - Visual Effects

/// Creates a blurred background effect for the main interface. Allows it to be called in SWiftUI.
struct VisualEffectView: NSViewRepresentable {
	let material: NSVisualEffectView.Material
	let blendingMode: NSVisualEffectView.BlendingMode
	let emphasized: Bool

	func makeNSView(context: Context) -> NSVisualEffectView {
		let visualEffectView = NSVisualEffectView()
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.material = material
		visualEffectView.state = NSVisualEffectView.State.active
		visualEffectView.blendingMode = blendingMode
		visualEffectView.isEmphasized = emphasized

		return visualEffectView
	}

	func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
		visualEffectView.material = material
		visualEffectView.blendingMode = blendingMode
		visualEffectView.isEmphasized = emphasized
	}
}

// MARK: - NS Extensions

/// Allowed NSPanel to be focusable
extension NSPanel {
	override open var canBecomeKey: Bool {
		return true
	}
}

// Resizes the bitmap of an NSImage
extension NSImage {
	/// Scales NSImage to the provided NSSize().
	/// [Skimmed off StackOverflow](https://stackoverflow.com/a/42915296/13142325)
	func resized(to newSize: NSSize) -> NSImage? {
		if let bitmapRep = NSBitmapImageRep(
			bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
			bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
			colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0
		) {
			bitmapRep.size = newSize
			NSGraphicsContext.saveGraphicsState()
			NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
			draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
			NSGraphicsContext.restoreGraphicsState()

			let resizedImage = NSImage(size: newSize)
			resizedImage.addRepresentation(bitmapRep)
			return resizedImage
		}

		return nil
	}
}

// MARK: - Miscellaneous Extensions

// Grabs the true home directory for the user
public extension FileManager {
	/// Grabs the /Users/username/ directory
	var getRealHomeDirectory: String? {
		if let home = getpwuid(getuid()).pointee.pw_dir {
			return string(withFileSystemRepresentation: home, length: Int(strlen(home)))
		}
		return nil
	}
}

/// Provides the current instance of the app delegate along with all fields present in the class.
extension AppDelegate {
	static func current() -> AppDelegate {
		return NSApp.delegate as! AppDelegate
	}
}

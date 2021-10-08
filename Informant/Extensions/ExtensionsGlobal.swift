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

// MARK: - Colors

extension Color {

	static let settingsPanelBacking = Color("settingsPanelBacking")
}

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

		// Loop the array and split each word from it's first letter. Capitalize the first letter and then concatenate
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

		#warning("This could get changed in the future: 'Volumes'")
		guard let fileCFURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, ("Volumes:" + self) as CFString?, CFURLPathStyle(rawValue: 1)!, hasSuffix(":")) else {
			return nil
		}

		let fileURL = fileCFURL as URL

		return fileURL.path
	}
}

// MARK: - URLs

extension URL {
	/// Converts an array of string paths to URLs
	static func convertPathsToURLs(_ urls: [String]) -> [URL] {
		var convertedURLs: [URL] = []
		for url in urls {
			convertedURLs.append(URL(fileURLWithPath: url))
		}
		return convertedURLs
	}
}

// MARK: - NS Extensions

/// Allowed NSPanel to be focusable. < I have no idea why I added this in the first place.
/*
 extension NSPanel {
 	override open var canBecomeKey: Bool {
 		return true
 	}
 }
  */

// Shortens NSPanel initialization
extension NSPanel {

	convenience init(width: CGFloat, height: CGFloat, styleMask: NSPanel.StyleMask) {
		self.init(
			contentRect: NSRect(x: 0, y: 0, width: width, height: height),
			styleMask: styleMask,
			backing: .buffered,
			defer: false
		)
	}
}

/// Allows NSWindow to be focusable
class NSIFWindow: NSWindow {

	init(_ styleMask: NSWindow.StyleMask) {
		super.init(
			contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
			styleMask: styleMask,
			backing: .buffered,
			defer: false
		)
	}

	override open var canBecomeKey: Bool {
		return true
	}

	override open var canBecomeMain: Bool {
		return true
	}

	override open var acceptsFirstResponder: Bool {
		return true
	}
}

/*
 /// Allows for an animate-able window
 class NSIFPanel: NSPanel {
 	var lastContentSize: CGSize = .zero

 	override func setContentSize(_ size: NSSize) {

 		if self.lastContentSize == size { return } // prevent multiple calls with the same size

 		self.lastContentSize = size

 		self.animator().setFrame(NSRect(origin: self.frame.origin, size: size), display: true, animate: true)
 	}
 }
 */

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

// Reads the inital state of the linked value
extension NSMenuItem {

	/// Simply sets the initial state of the nsmenuitem
	func manageState(setting: Bool, on: () -> Void, off: () -> Void) {
		if setting == true {
			on()
		} else {
			off()
		}
	}

	/// Makes the button more juicy to click
	func juicyWithoutImage() {
		self.image = NSImage()
		self.image?.size = NSSize(width: 0.01, height: Style.Menu.juicyImageHeight)
	}

	/// Makes the button more juicy to click when an image is present
	func juicyWithImage() {
		self.image?.isTemplate = true
		self.image?.size = NSSize(width: Style.Menu.juicyImageWidth, height: Style.Menu.juicyImageHeight)
	}

	/// Sets up the image for the nsmenuitem
	func setupImage(_ resourceName: String) {
		self.image = #imageLiteral(resourceName: resourceName)
		self.juicyWithImage()
	}
}

// MARK: - View Extensions

extension View {
	/// Applies the given transform if the given condition evaluates to `true`.
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}

// MARK: - Miscellaneous Extensions

// Grabs the true home directory for the user
public extension FileManager {
	/// Grabs the /Users/username/ directory
	var getRealHomeDirectory: String? {

		let home = FileManager.default.homeDirectoryForCurrentUser.path

		guard let volumeName = FileManager.default.componentsToDisplay(forPath: home)?.first else {
			return nil
		}

		#warning("This could get changed in the future: 'Volumes'")
		return "/Volumes/\(volumeName)\(home)"
	}

	/// Grabs the /username/ directory
	var getHomeDirectory: String? {
		return FileManager.default.homeDirectoryForCurrentUser.path
	}

	/// Grabs the /Volumes/<Root Drive>/ components
	var getRootVolumeAsPath: String? {

		guard let volumeName = getRootVolumeName else {
			return nil
		}

		#warning("This could get changed in the future: 'Volumes'")
		return "/Volumes/\(volumeName)"
	}

	/// Gets the volume's name
	var getRootVolumeName: String? {
		let home = FileManager.default.homeDirectoryForCurrentUser.path
		return FileManager.default.componentsToDisplay(forPath: home)?.first
	}
}

/// Provides the current instance of the app delegate along with all fields present in the class.
extension AppDelegate {
	static func current() -> AppDelegate {
		return NSApp.delegate as! AppDelegate
	}
}

/// Converts approximated numbers into rational fractions.
/// [Pimped from SO](https://stackoverflow.com/a/35895607/13142325)
struct Rational {
	let numerator: Int
	let denominator: Int

	init(numerator: Int, denominator: Int) {
		self.numerator = numerator
		self.denominator = denominator
	}

	init(approximating x0: Double, withPrecision eps: Double = 1.0E-6) {
		var x = x0
		var a = x.rounded(.down)
		var (h1, k1, h, k) = (1, 0, Int(a), 1)

		while x - a > eps * Double(k) * Double(k) {
			x = 1.0 / (x - a)
			a = x.rounded(.down)
			(h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
		}
		self.init(numerator: h, denominator: k)
	}
}

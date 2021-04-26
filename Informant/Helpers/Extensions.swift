//
//  Extensions.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation

// MARK: - Extensions
// Use this file for storing any sort of extensions to classes.

extension String {
	var numberOfWords: Int {
		var count = 0
		let range = startIndex ..< endIndex
		enumerateSubstrings(in: range, options: [.byWords, .substringNotRequired, .localized]) { _, _, _, _ -> () in
			count += 1
		}
		return count
	}
}

extension String {
	var capitalizeEachWord: String {
		// break it into an array by delimiting the sentence using a space
		let breakupSentence = self.components(separatedBy: " ")
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

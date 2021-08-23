//
//  LinkHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-08-08.
//

import Foundation
import SwiftUI

class LinkHelper {

	/// Opens a link in the default browser.
	static func openLink(link: String) {
		if let url = URL(string: link) {
			NSWorkspace.shared.open(url)
		}
	}

	/// Opens a file in preview.
	static func openPDF(link: String) {
		if let url = Bundle.main.url(forResource: link, withExtension: "pdf") {
			NSWorkspace.shared.open(url)
		}
	}
}

enum Links {

	static let domain = "informant-app.com"

	static let site = "https://\(domain)"

	// ---------------------------------

	static let email = "help@\(domain)"

	static let privacyPolicy = "\(site)/#privacy"

	static let feedback = "https://github.com/tyirvine/Informant-Issue-Tracker"

	static let feedbackMail = "mailto:\(email)"

	static let help = "\(site)/#faq"

	static let acknowledgements = "(Informant_-_File_Inspector_for_macOS)_Acknowledgements"
}

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
}

enum Links {

	static let domain = "informant-app.com"

	static let site = "https://\(domain)"

	// ---------------------------------

	static let email = "help@\(domain)"

	#warning("Remove from production: fill out links")

	static let privacyPolicy = "\(site)/#"

	static let feedback = "mailto:\(email)"

	static let help = "\(site)/#"
}

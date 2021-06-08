//
//  InterfaceObservable.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-07.
//

import Foundation

/// Parameters can be added here that need to be observed for the content view
class SettingsData: ObservableObject {

	/// Detects if the panel itself is in the panel snap zone
	@Published var isPanelInSnapZone: Bool = false

	/// Helper designed to set the in snap zone of panel
	public func setIsPanelInSnapZone(_ value: Bool) {
		isPanelInSnapZone = value
	}
}

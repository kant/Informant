//
//  InterfaceObservable.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-07.
//

import Foundation

/// Parameters can be added here that need to be observed for the content view
class InterfaceState: ObservableObject {

	/// Detects if the panel itself is in the panel snap zone
	@Published var isPanelInSnapZone: Bool = false

	/// Helper designed to set the in snap zone of panel
	public func setIsPanelInSnapZone(_ value: Bool) {
		isPanelInSnapZone = value
	}

	/// Keeps track of state of path switch
	@Published var isPathExpanded: Bool = false

	public func setIsPathExpanded(_ value: Bool) {
		isPathExpanded = value
	}

	/// Keeps track of whether the mouse is hovering on the panel
	@Published var isMouseHoveringPanel: Bool = false

	@Published var isMouseHoveringClose: Bool = false

	/// Hover zones for the close button
	public enum CloseHoverZones {
		case Button
		case Panel
	}

	/// Keeps track of which hover zone the mouse is in
	@Published var closeHoverZone: CloseHoverZones?
}

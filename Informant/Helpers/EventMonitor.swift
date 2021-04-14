//
//  EventLogic.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Cocoa
import Foundation

class EventMonitor {

	private var monitor: Any?
	private let mask: NSEvent.EventTypeMask
	private let handler: (NSEvent) -> Void

	public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
		self.mask = mask
		self.handler = handler
	}

	deinit {
		stop()
	}

	public func start() {
		monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as! NSObject
	}

	public func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}
}

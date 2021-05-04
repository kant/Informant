//
//  EventLogic.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Cocoa
import Foundation

// This class listens for any requested actions and can be used to execute logic.
// So say I wanted to know when the user left clicks, this is the class to use.
class GlobalEventMonitor {

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

class LocalEventMonitor {

	private var monitor: Any?
	private let mask: NSEvent.EventTypeMask
	private let handler: (NSEvent) -> NSEvent?

	public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> NSEvent?) {
		self.mask = mask
		self.handler = handler
	}

	deinit {
		stop()
	}

	public func start() {
		monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: handler)
	}

	public func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}
}

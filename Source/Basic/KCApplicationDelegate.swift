/**
 * @file	KCApplicationDelegate.swift
 * @brief	Define KCApplicationDelegate class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

open class KCApplicationDelegate: CNApplicationDelegate
{
	open override func applicationDidFinishLaunching(_ notification: Notification) {
		/* Call super class first */
		super.applicationDidFinishLaunching(notification)
		/* Connect console to the event manager */
		#if os(OSX)
			let evtmgr = CNAppleEventManager.shared()
			let logmgr = KCLogManager.shared
			logmgr.enable = true
			evtmgr.console = logmgr.console
			evtmgr.dump()
		#endif
	}
}

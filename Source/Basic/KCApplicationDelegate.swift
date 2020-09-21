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
	#if os(OSX)
	open override func applicationDidFinishLaunching(_ notification: Notification) {
		/* Call super class first */
		super.applicationDidFinishLaunching(notification)
		/* Allocate log manager */
		let _ = KCLogManager.shared
	}
	#endif
}

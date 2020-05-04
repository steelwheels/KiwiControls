/**
 * @file	KCLogManager.swift
 * @brief	Define KCLogManager class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLogManager: CNLogManager
{
	public static var shared	= KCLogManager()
	#if os(OSX)
		private var		mWindowController: KCLogWindowController?
	#else
		private weak var	mViewController: KCLogViewController?
	#endif

	public override init() {
		#if os(OSX)
			mWindowController	= nil
		#else
			mViewController		= nil
		#endif
		super.init()
	}

	public var enable: Bool {
		get {
			#if os(OSX)
				if let cont = mWindowController {
					return cont.isVisible
				} else {
					return false
				}
			#else
				return false
			#endif
		}
		set(newval) {
			if newval {
				#if os(OSX)
					let console: CNConsole
					if let cont = mWindowController {
						console	= cont.console
						cont.show()
					} else {
						let newcont = KCLogWindowController.allocateController()
						mWindowController = newcont
						console = newcont.console
						newcont.show()
					}
					super.setOutput(console: console)
				#else
				#endif
			} else {
				#if os(OSX)
					if let cont = mWindowController {
						cont.hide()
					}
					super.setOutput(console: nil)
				#else
				#endif
			}
		}
	}
}


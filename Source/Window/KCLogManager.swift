/**
 * @file	KCLogManager.swift
 * @brief	Define KCLogManager class
 * @par Copyright
 *   Copyright (C) 2018-2020 Steel Wheels Project
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

	open override func updateLogLevel(logLevel lvl: CNLogManager.LogLevel) {
		let isvis = self.isVisible
		let doen  = checkEnable(logLevel: lvl)
		if !isvis && doen {
			/* Set enable */
			doShow()
		} else if isvis && !doen {
			/* Set disable */
			doHide()
		}
	}

	private func checkEnable(logLevel lvl: LogLevel) -> Bool {
		let result: Bool
		switch lvl {
		case .nolog:	result = false
		default:	result = true
		}
		return result
	}

	private func doShow() {
		#if os(OSX)
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			let console: CNConsole
			if let cont = self.mWindowController {
				console	= cont.console
				cont.show()
			} else {
				let newcont = KCLogWindowController.allocateController()
				self.mWindowController = newcont
				console = newcont.console
				newcont.show()
			}
			super.setOutput(console: console)
		})
		#endif
	}

	private func doHide() {
		#if os(OSX)
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			if let cont = self.mWindowController {
				cont.hide()
			}
			super.setOutput(console: nil)
		})
		#endif
	}

	public var isVisible: Bool {
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
	}
}


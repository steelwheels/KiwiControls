/**
 * @file	KCLogManager.swift
 * @brief	Define KCLogManager class
 * @par Copyright
 *   Copyright (C) 2018-2020 Steel Wheels Project
 */

import CoconutData
import Foundation

@objc public class KCLogManager: NSObject
{
	public typealias LogLevel = CNConfig.LogLevel

	public static var shared	= KCLogManager()
	#if os(OSX)
		private var		mWindowController: KCLogWindowController?
	#else
		private weak var	mViewController: KCLogViewController?
	#endif

	private override init() {
		#if os(OSX)
			mWindowController	= nil
		#else
			mViewController		= nil
		#endif
		super.init()

		/* Observe LogLevel item */
		let syspref = CNPreference.shared.systemPreference
		syspref.addObserver(observer: self, forKey: CNSystemPreference.LogLevelItem)
	}

	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		switch keyPath {
		case CNSystemPreference.LogLevelItem:
			if let vals = change {
				if let newval = vals[.newKey] as? Int {
					if let newlevel = CNSystemPreference.LogLevel(rawValue: newval) {
						updateLogLevel(logLevel: newlevel)
					}
				}
			}
		default:
			CNLog(logLevel: .error, message: "oV: \(String(describing: keyPath))")
		}
	}

	private func updateLogLevel(logLevel lvl: LogLevel) {
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
			/* Connect log buffer to this window */
			let buf = CNLogBuffer.shared
			buf.setOutput(console: console)
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
			/* Connect log buffer to this window */
			let buf = CNLogBuffer.shared
			buf.resetOutput()
		})
		#endif
	}

	public var console: CNConsole? {
		get {
			#if os(OSX)
				if let cont = mWindowController {
					return cont.console
				} else {
					return nil
				}
			#else
				return nil
			#endif
		}
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


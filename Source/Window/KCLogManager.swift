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

	public static let shared	= KCLogManager()
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

	deinit {
		let syspref = CNPreference.shared.systemPreference
		syspref.removeObserver(observer: self, forKey: CNSystemPreference.LogLevelItem)
	}

	public func start() {
		let level = CNPreference.shared.systemPreference.logLevel
		updateLogLevel(logLevel: level)
	}

	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		switch keyPath {
		case CNSystemPreference.LogLevelItem:
			if let vals = change {
				if let newval = vals[.newKey] as? Int {
					if let newlevel = CNSystemPreference.LogLevel(rawValue: newval) {
						CNExecuteInMainThread(doSync: false, execute: {
							() -> Void in self.updateLogLevel(logLevel: newlevel)
						})
					}
				}
			}
		default:
			CNLog(logLevel: .detail, message: "Unexpected event:  \(String(describing: keyPath))", atFunction: #function, inFile: #file)
		}
	}

	private func updateLogLevel(logLevel lvl: LogLevel) {
		let isvis = self.isVisible
		let doen  = (lvl != .nolog)
		if !isvis && doen {
			/* Set enable */
			doShow()
		} else if isvis && !doen {
			/* Set disable */
			doHide()
		}
	}

	private func doShow() {
		#if os(OSX)
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
		CNLogManager.shared.pushConsone(console: console)
		#endif
	}

	private func doHide() {
		#if os(OSX)
		if let cont = self.mWindowController {
			cont.hide()
		}
		/* Connect log buffer to this window */
		CNLogManager.shared.popConsole()
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


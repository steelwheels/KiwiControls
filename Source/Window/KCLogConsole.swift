/**
 * @file	KCLogConsole.swift
 * @brief	Define KCLogConsole class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLogConsole: CNConsole
{
	private static var	mShared:	KCLogConsole? = nil

	public static var shared: KCLogConsole {
		get {
			if let cons = mShared {
				return cons
			} else {
				let newcons = KCLogConsole()
				mShared = newcons
				return newcons
			}
		}
	}

	public var 	enable: Bool = true

	#if os(OSX)
		private var		mWindowController: KCLogWindowController
	#else
		private weak var	mViewController: KCLogViewController?
	#endif

	private init(){
		#if os(OSX)
			mWindowController = KCLogWindowController.allocateController()
		#else
			mViewController = nil
		#endif
	}

	#if os(iOS)
	public var viewController: KCLogViewController? {
		get { return mViewController }
		set(newview) { mViewController = newview }
	}
	#endif

	public func show() {
		#if os(OSX)
		mWindowController.show()
		#else
		#endif
	}

	public func hide() {
		#if os(OSX)
		mWindowController.hide()
		#else
		#endif
	}

	open func print(string str: String){
		if enable {
			#if os(OSX)
			//NSLog("LogCons: print \(str)\n")
			mWindowController.show()
			return mWindowController.print(string: str)
			#else
			if let cons = mViewController?.consoleConnection {
				cons.print(string: str)
			} else {
				Swift.print(str, terminator: "")
			}
			#endif
		}
	}

	open func error(string str: String){
		if enable {
			#if os(OSX)
			//NSLog("LogCons: error \(str)\n")
			mWindowController.show()
			return mWindowController.error(string: str)
			#else
			if let cons = mViewController?.consoleConnection {
				cons.error(string: str)
			} else {
				Swift.print(str, terminator: "")
			}
			#endif
		}
	}

	open func scan() -> String? {
		if enable {
			#if os(OSX)
			return mWindowController.scan()
			#else
			if let cons = mViewController?.consoleConnection {
				return cons.scan()
			} else {
				return nil
			}
			#endif
		} else {
			return nil
		}
	}
}


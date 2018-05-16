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
	public var 		enable: Bool = true

	#if os(OSX)
	private weak var	mWindowController: KCLogWindowController? = nil
	private var windowController: KCLogWindowController {
		get {
			if let cont = mWindowController {
				return cont
			} else {
				let newcont = KCLogWindowController.allocateController()
				mWindowController = newcont
				newcont.show()
				return newcont
			}
		}
	}
	#endif // os(OSX)

	public func show() {
		#if os(OSX)
			windowController.show()
		#else
		#endif
	}

	public func hide() {
		#if os(OSX)
			windowController.hide()
		#else
		#endif
	}

	open override func print(string str: String){
		if enable {
			#if os(OSX)
				return windowController.print(string: str)
			#else
				let console = KCLogViewController.shared.inputConsole
				console.print(string: str)
			#endif
		}
	}

	open override func error(string str: String){
		if enable {
			#if os(OSX)
				return windowController.error(string: str)
			#else
				let console = KCLogViewController.shared.inputConsole
				console.error(string: str)
			#endif
		}
	}

	open override func scan() -> String? {
		if enable {
			#if os(OSX)
				return windowController.scan()
			#else
				let console = KCLogViewController.shared.inputConsole
				return console.scan()
			#endif
		} else {
			return nil
		}
	}
}


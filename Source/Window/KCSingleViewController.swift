/**
 * @file	KCSingleViewController.swift
 * @brief	Define KCSingleViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(iOS)
import UIKit
#else
import Cocoa
#endif
import CoconutData

open class KCSingleViewController: KCPlaneViewController
{
	private weak var	mParentController:	KCMultiViewController?
	private var 		mHasOwnConsole:		Bool

	public init(parentViewController parent: KCMultiViewController){
		mParentController	= parent
		mHasOwnConsole		= false
		super.init()
	}

	public required init?(coder: NSCoder) {
		mParentController	= nil
		mHasOwnConsole		= false
		super.init(coder: coder)
	}

	public var globalConsole: CNFileConsole {
		get {
			if let mgr = parentController.consoleManager {
				return mgr.console
			} else {
				NSLog("[Error] No console manager to get at \(#file)")
				return CNFileConsole()
			}
		}
		set(newcons) {
			if let mgr = parentController.consoleManager {
				if !mHasOwnConsole {
					//NSLog("push global console")
					mgr.push(console: newcons)
					mHasOwnConsole = true
				} else {
					NSLog("[Error] Global cosole is already set \(#file)")
				}
			} else {
				NSLog("[Error] No console manager to set at \(#file)")
			}
		}
	}

	open func viewWillBecomeForeground() {
	}

	open func viewWillBecomeBackground() {
	}

	open func viewWillRemoved() {
		if mHasOwnConsole {
			if let mgr = parentController.consoleManager {
				//NSLog("pop global console")
				let _ = mgr.pop()
			} else {
				NSLog("[Error] No console manager to pop at \(#file)")
			}
		}
	}

	open override func parentSize() -> KCSize? {
		if let parctrl = mParentController {
			return parctrl.view.frame.size
		} else {
			return nil
		}
	}

	public func setParentSize(_ size: KCSize) {
		if let parctrl = mParentController {
			parctrl.view.frame.size  = size
			parctrl.view.bounds.size = size
		}
	}

	public var parentController: KCMultiViewController {
		get {
			if let controller = mParentController {
				return controller
			} else {
				fatalError("Can not happen")
			}
		}
	}
}



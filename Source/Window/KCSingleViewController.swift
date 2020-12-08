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

@objc public class KCSingleViewState: NSObject {
	public var isForeground: Bool

	public override init() {
		isForeground = false
	}
}


open class KCSingleViewController: KCPlaneViewController
{
	private weak var	mParentController:	KCMultiViewController?
	private var 		mHasOwnConsole:		Bool
	private var		mViewState:		KCSingleViewState

	public init(parentViewController parent: KCMultiViewController){
		mParentController	= parent
		mHasOwnConsole		= false
		mViewState		= KCSingleViewState()
		super.init()
	}

	public required init?(coder: NSCoder) {
		mParentController	= nil
		mHasOwnConsole		= false
		mViewState		= KCSingleViewState()
		super.init(coder: coder)
	}

	public var viewState: KCSingleViewState { get { return mViewState }}

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
		mViewState.isForeground = true
	}

	open func viewWillBecomeBackground() {
		mViewState.isForeground = false
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



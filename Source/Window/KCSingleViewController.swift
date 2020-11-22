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
	public var		isInFront:		Bool

	public init(parentViewController parent: KCMultiViewController){
		mParentController	= parent
		isInFront		= false
		super.init()
	}

	public required init?(coder: NSCoder) {
		mParentController	= nil
		isInFront		= false
		super.init(coder: coder)
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



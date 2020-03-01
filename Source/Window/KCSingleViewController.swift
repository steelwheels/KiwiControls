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
	private weak var mParentController:	KCMultiViewController?

	public init(parentViewController parent: KCMultiViewController, console cons: CNConsole){
		mParentController	= parent
		super.init(console: cons)
	}

	public required init?(coder: NSCoder) {
		mParentController	= nil
		super.init(coder: coder)
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



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

open class KCSingleViewController: KCViewController
{
	private weak var mParentController:	KCMultiViewController?
	private var mConsole:			CNConsole
	private var mEntireView:		KCView? = nil
	private var mRootView:			KCRootView? = nil

	public init(parentViewController parent: KCMultiViewController, console cons: CNConsole){
		mParentController	= parent
		mConsole     		= cons
		super.init(nibName: nil, bundle: nil)
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var parentController: KCMultiViewController? {
		get { return mParentController }
	}

	public var entireView: KCView? {
		get { return mEntireView }
	}

	public var rootView: KCRootView? {
		get { return mRootView }
	}

	public var safeAreaInset: KCEdgeInsets {
		if let parent = mParentController {
			return KCViewController.safeAreaInsets(viewController: parent)
		} else {
			return KCViewController.safeAreaInsets(viewController: self)
		}
	}
	
	public var safeFrame: KCRect {
		if let parent = mParentController {
			return KCViewController.safeFrame(viewController: parent)
		} else {
			return KCViewController.safeFrame(viewController: self)
		}
	}

	public var entireFrame: KCRect {
		if let parent = mParentController {
			return KCViewController.entireFrame(viewController: parent)
		} else {
			return KCViewController.entireFrame(viewController: self)
		}
	}

	open override func loadView() {
		let entire = KCView(frame: KCRect(origin: KCPoint.zero, size: KCSize(width: 100.0, height: 100.0)))
		self.view = entire
		mEntireView = entire

		let root = allocateRootView()
		entire.addSubview(root)
		mRootView = root
	}

	open func allocateRootView() -> KCRootView {
		return KCRootView()
	}

	#if os(OSX)
	open override func viewWillAppear() {
		super.viewWillAppear()
		doViewWillAppear()
	}
	#else
	open override func viewWillAppear(_ animated: Bool){
		super.viewWillAppear(animated)
		doViewWillAppear()
	}
	#endif

	private func doViewWillAppear() {
		if let root = mRootView {
			if root.hasCoreView {
				/* Adjust size */
				let layouter = KCLayouter(viewController: self, console: mConsole)
				layouter.layout(rootView: root)
			} else {
				NSLog("\(#function): Error no core view")
			}
		} else {
			fatalError("No root view")
		}
	}
}



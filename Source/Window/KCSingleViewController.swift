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
	private var mRootView:			KCRootView? = nil

	public init(parentViewController parent: KCMultiViewController, console cons: CNConsole){
		mParentController	= parent
		mConsole     		= cons
		super.init(nibName: nil, bundle: nil)
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public var rootView: KCRootView? {
		get { return mRootView }
	}
	
	open override func loadView() {
		/* Allocate root view */
		let safearea = safeArea()
		let root     = allocateRootView(frame: safearea)
		self.view    = root
		mRootView    = root
	}

	open func allocateRootView(frame frm: KCRect) -> KCRootView {
		return KCRootView(frame: frm)
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
				let savearea = safeArea()
				let layouter = KCLayouter(rootFrame: savearea, console: mConsole)
				layouter.layout(rootView: root)
			} else {
				NSLog("\(#function): Error no core view")
			}
		} else {
			fatalError("No root view")
		}
	}

	public func safeArea() -> KCRect {
		let result: KCRect
		if let parent = mParentController {
			result = KCViewController.safeArea(viewController: parent)
		} else {
			result = KCViewController.safeArea(viewController: self)
		}
		return result
	}
}



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
	private var mDoVerbose:			Bool
	private var mRootView:			KCRootView? = nil
	private var mLayoutedSize:		KCSize

	public init(parentViewController parent: KCMultiViewController, console cons: CNConsole, doVerbose doverb: Bool){
		mParentController	= parent
		mConsole     		= cons
		mDoVerbose		= doverb
		mLayoutedSize		= KCSize.zero
		super.init(nibName: nil, bundle: nil)
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var parentController: KCMultiViewController? {
		get { return mParentController }
	}

	public var console: CNConsole {
		get { return mConsole }
	}

	public var rootView: KCRootView? {
		get { return mRootView }
	}

	open override func loadView() {
		let root  = allocateRootView()
		self.view = root
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
				let winsize = KCLayouter.windowSize(viewController: self)
				if winsize != mLayoutedSize {
					/* Layout components */
					CNLog(type: .Flow, message: "// Execute Layout", file: #file, line: #line, function: #function)
					let layouter = KCLayouter(viewController: self, console: mConsole, doVerbose: mDoVerbose)
					layouter.layout(rootView: root, windowSize: winsize)
					/* This size is layouted */
					mLayoutedSize = winsize
				} else {
					CNLog(type: .Flow, message: "// Skip layout", file: #file, line: #line, function: #function)
				}
			}
		} else {
			CNLog(type: .Error, message: "No root view", file: #file, line: #line, function: #function)
		}
	}
}



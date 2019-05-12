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

open class KCSingleViewController: KCViewController, CNLogging
{
	private weak var mParentController:	KCMultiViewController?
	private var mRootView:			KCRootView? = nil
	private var mLayoutedSize:		KCSize
	private var mConsole:			CNConsole

	public init(parentViewController parent: KCMultiViewController, console cons: CNConsole){
		mParentController	= parent
		mLayoutedSize		= KCSize.zero
		mConsole     		= cons
		super.init(nibName: nil, bundle: nil)
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	public var parentController: KCMultiViewController? {
		get { return mParentController }
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
		return KCRootView(console: mConsole)
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
				let winsize = KCLayouter.windowSize(viewController: self, console: mConsole)
				if winsize != mLayoutedSize {
					/* Layout components */
					log(type: .Flow, string: "Execute Layout", file: #file, line: #line, function: #function)
					let layouter = KCLayouter(viewController: self, console: mConsole)
					layouter.layout(rootView: root, windowSize: winsize)
					/* This size is layouted */
					mLayoutedSize = winsize
				} else {
					log(type: .Flow, string: "// Skip layout", file: #file, line: #line, function: #function)
				}
			}
		} else {
			log(type: .Error, string: "No root view", file: #file, line: #line, function: #function)
		}
	}

	#if os(OSX)
	open override func viewDidAppear() {
		super.viewDidAppear()
		doViewDidAppear()
	}
	#else
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		doViewDidAppear()
	}
	#endif

	private func doViewDidAppear(){
		if let root = mRootView {
			if root.hasCoreView {
				let finalizer = KCLayoutFinalizer(console: mConsole)
				finalizer.finalizeLayout(rootView: root)
			}
		}
	}
}



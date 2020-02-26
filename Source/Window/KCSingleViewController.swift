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

	public var parentController: KCMultiViewController {
		get {
			if let controller = mParentController {
				return controller
			} else {
				fatalError("Can not happen")
			}
		}
	}

	public var rootView: KCRootView? {
		get { return mRootView }
	}

	open override func loadView() {
		super.loadView()
		if mRootView == nil {
			/* Get original size */
			#if os(OSX)
			let size = self.view.frame.size
			#else
			let size = UIScreen.main.bounds.size
			#endif

			/* Keep the size */
			self.preferredContentSize = size

			let root = allocateRootView()
			root.frame.size  = size
			root.bounds.size = size
			self.view = root
			mRootView = root
			//NSLog("Root size: \(root.frame.size)")
		}
	}

	open func allocateRootView() -> KCRootView {
		return KCRootView(console: mConsole)
	}

	#if os(OSX)
	open override func viewWillLayout() {
		super.viewWillLayout()
		doViewWillLayout()
	}
	#else
	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		doViewWillLayout()
	}
	#endif

	private func doViewWillLayout() {
		if let root = mRootView {
			if root.hasCoreView {
				let newsize = self.preferredContentSize
				if newsize != mLayoutedSize {
					/* Layout components */
					log(type: .flow, string: "Execute Layout", file: #file, line: #line, function: #function)
					let layouter = KCLayouter(console: mConsole)
					layouter.layout(rootView: root, contentSize: newsize)
					/* This size is layouted */
					mLayoutedSize = newsize
				} else {
					log(type: .flow, string: "Skip layout", file: #file, line: #line, function: #function)
				}
			}
		} else {
			log(type: .error, string: "No root view", file: #file, line: #line, function: #function)
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

	public func windowDidResize(parentViewController parent: KCMultiViewController) {
	}

	private func doViewDidAppear(){
		if let root = mRootView {
			if root.hasCoreView {
				let finalizer = KCLayoutFinalizer(console: mConsole)
				finalizer.finalizeLayout(rootView: root)
				/* Make first responder
				 * reference: https://stackoverflow.com/questions/7263482/problems-setting-firstresponder-in-cocoa-mac-osx
				 */
				/*
				let maker = KCFirstResponderMaker(console: mConsole)
				if !maker.makeFirstResponder(rootView: root) {
					log(type: .flow, string: "No first responder", file: #file, line: #line, function: #function)
				}*/
			}
		}
	}
}



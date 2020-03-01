/**
 * @file	KCPlaneViewController.swift
 * @brief	Define KCPlaneViewController class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(iOS)
import UIKit
#else
import Cocoa
#endif
import CoconutData

open class KCPlaneViewController: KCViewController, KCWindowDelegate, KCViewControlEventReceiver, CNLogging
{
	private var mRootView:			KCRootView? = nil
	private var mTargetSize:		KCSize
	private var mConsole:			CNConsole

	public init(console cons: CNConsole){
		mTargetSize	= KCSize.zero
		mConsole     	= cons
		super.init(nibName: nil, bundle: nil)
	}

	#if os(OSX)
	public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		mRootView	= nil
		mConsole	= KCLogManager.shared.console
		mTargetSize	= KCSize.zero
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	#else
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		mRootView	= nil
		mConsole	= KCLogManager.shared.console
		mTargetSize	= KCSize.zero
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	#endif

	public required init?(coder: NSCoder) {
		mRootView	= nil
		mConsole	= KCLogManager.shared.console
		mTargetSize	= KCSize.zero
		super.init(coder: coder)
	}

	public var console: CNConsole? {
		get { return mConsole }
	}

	open func allocateRootView() -> KCRootView {
		return KCRootView(console: mConsole)
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
			mTargetSize = size

			let root = allocateRootView()
			root.frame.size  = size
			root.bounds.size = size
			self.view = root
			mRootView = root
			//NSLog("Root size: \(root.frame.size)")
		}
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

	var mPrevRootSize = KCSize.zero

	private func doViewWillLayout() {
		if let root = mRootView {
			if root.hasCoreView {
				/* Layout components */
				let newsize = mTargetSize
				if mPrevRootSize != newsize {
					log(type: .flow, string: "Execute Layout", file: #file, line: #line, function: #function)
					let layouter = KCLayouter(console: mConsole)
					layouter.layout(rootView: root, contentSize: newsize)
					mPrevRootSize = newsize
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

	private func doViewDidAppear(){
		guard let window = self.view.window else {
			NSLog("No window")
			return
		}
		if let root = mRootView {
			if root.hasCoreView {
				let finalizer = KCLayoutFinalizer(console: mConsole)
				finalizer.finalizeLayout(window: window, rootView: root)
			}
		}
	}

	public func windowDidResize(parentViewController parent: KCMultiViewController) {
	}

	public func updateWindowSize() {
		if let root = mRootView {
			let newsize = root.fittingSize
			NSLog("updated size: \(newsize.description)")
			mTargetSize = newsize
		}
	}
}


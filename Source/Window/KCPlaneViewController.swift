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

open class KCPlaneViewController: KCViewController, KCWindowDelegate, KCViewControlEventReceiver
{
	private var mRootView:			KCRootView? = nil
	private var mTargetSize:		KCSize

	public init(){
		mTargetSize	= KCSize.zero
		super.init(nibName: nil, bundle: nil)
	}

	#if os(OSX)
	public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		mRootView	= nil
		mTargetSize	= KCSize.zero
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	#else
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		mRootView	= nil
		mTargetSize	= KCSize.zero
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	#endif

	public required init?(coder: NSCoder) {
		mRootView	= nil
		mTargetSize	= KCSize.zero
		super.init(coder: coder)
	}

	open func allocateRootView() -> KCRootView {
		return KCRootView()
	}

	public var rootView: KCRootView? {
		get { return mRootView }
	}

	open override func loadView() {
		super.loadView()
		if mRootView == nil {
			let root = allocateRootView()

			/* Allocate contents by super class */
			let retsize = loadViewContext(rootView: root)

			/* Keep the size */
			let contentsize: KCSize
			#if os(OSX)
				contentsize = retsize
			#else
				if let window = self.view.window {
					contentsize = window.bounds.size
				} else {
					contentsize = UIScreen.main.bounds.size
				}
			#endif
			mTargetSize = contentsize

			root.frame.size  = contentsize
			root.bounds.size = contentsize
			self.view = root
			mRootView = root
		}
	}

	open func loadViewContext(rootView root: KCRootView) -> KCSize {
		NSLog("\(#file) Override this method")
		return root.frame.size
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
					CNLog(logLevel: .debug, message: "Execute Layout")
					let layouter = KCLayouter()
					layouter.layout(rootView: root, contentSize: newsize)
					mPrevRootSize = newsize
				}
			}
		} else {
			CNLog(logLevel: .error, message: "No root view")
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
				let finalizer = KCLayoutFinalizer()
				finalizer.finalizeLayout(window: window, rootView: root)
			}
		}
	}

	public func windowDidResize(parentViewController parent: KCMultiViewController) {
	}

	public func updateWindowSize() {
		if let root = mRootView {
			let newsize = root.fittingSize
			NSLog("updated window size: \(newsize.description)")
			mTargetSize = newsize
			#if os(OSX)
			if let win = self.view.window {
				win.resize(size: newsize)
			}
			#endif
			root.setNeedsLayout()
		}
	}
}


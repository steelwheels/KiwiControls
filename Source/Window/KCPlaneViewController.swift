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
	private var mRootView:			KCRootView?
	private var mTargetSize:		KCSize

	public init(){
		mRootView	= nil
		mTargetSize	= KCSize.zero
		super.init(nibName: nil, bundle: nil)
	}
	
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

	#if os(OSX)
	open override func viewDidLayout() {
		super.viewDidLayout()
		doViewDidLayout()
	}
	#else
	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		doViewDidLayout()
	}
	#endif

	private func doViewDidLayout() {
		CNLog(logLevel: .debug, message: "[viewDidLayout]")
		if let root = mRootView {
			dumpInfo(phase: "- [doViewDidLayout]", rootView: root)
		}
	}

	var mPrevRootSize = KCSize.zero

	private func doViewWillLayout() {
		if let root = mRootView {
			if root.hasCoreView {
				/* Layout components */
				dumpInfo(phase: "doViewWillLayouut (before) target=\(mTargetSize.description)", rootView: root)
				let newsize = mTargetSize
				if mPrevRootSize != newsize {
					CNLog(logLevel: .debug, message: "- [Execute Layout]")
					let layouter = KCLayouter()
					layouter.layout(rootView: root, contentSize: newsize)
					mPrevRootSize = newsize
				}
				dumpInfo(phase: "doViewWillLayouut (after) target=\(mTargetSize.description)", rootView: root)
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
		CNLog(logLevel: .debug, message: "[viewDidAppear]")
		guard let window = self.view.window else {
			CNLog(logLevel: .error, message: "No window")
			return
		}
		if let root = mRootView {
			if root.hasCoreView {
				let finalizer = KCLayoutFinalizer()
				finalizer.finalizeLayout(window: window, rootView: root)
			}
			dumpInfo(phase: "- [doViewDidAppear]", rootView: root)
		}
	}

	public func windowDidResize(parentViewController parent: KCMultiViewController) {
	}

	public func updateWindowSize() {
		if let root = mRootView {
			let newsize = root.fittingSize
			mTargetSize = newsize
			#if os(OSX)
			if let win = self.view.window {
				win.resize(size: newsize)
			}
			#endif
			root.setNeedsLayout()
			dumpInfo(phase: "updateWindowSize (setNeedsToLayout) ", rootView: root)
		}
	}

	private func dumpInfo(phase str: String, rootView root: KCRootView) {
		let frame = root.frame
		CNLog(logLevel: .debug, message: "[\(str)] root-frame: \(frame.description)")
	}
}


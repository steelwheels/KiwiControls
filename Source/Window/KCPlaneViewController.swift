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

	public init(){
		mRootView	= nil
		super.init(nibName: nil, bundle: nil)
	}
	
	public required init?(coder: NSCoder) {
		mRootView	= nil
		super.init(coder: coder)
	}

	public var rootView: KCRootView? {
		get { return mRootView }
	}

	open override func loadView() {
		//super.loadView() <- Do not call this because it load NIB file (it is NOT exist)
		if mRootView == nil {
			/* Initialize log manager */
			let _ = KCLogManager.shared
			/* Allocate contents by super class */
			let root = KCRootView()
			loadViewContext(rootView: root)
			/* Assign as root of this controller*/
			self.view = root
			mRootView = root
		}
	}

	open func loadViewContext(rootView root: KCRootView) {
		NSLog("\(#file) Override this method")
	}

	open func parentSize() -> KCSize? {
		return nil
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

	private func doViewWillLayout() {
		if let root = mRootView {
			if root.hasCoreView {
				/* Layout components */
				NSLog("doViewWillLayout ... exec")
				//dumpInfo(phase: "doViewWillLayouut (before)", rootView: root)
				CNLog(logLevel: .debug, message: "- [Execute Layout]")
				let layouter    = KCLayouter()
				layouter.layout(rootView: root)
				//dumpInfo(phase: "doViewWillLayouut (after)", rootView: root)
			}
		} else {
			CNLog(logLevel: .error, message: "No root view")
		}
	}

	private func doViewDidAppear() {
		#if os(OSX)
			if let window = self.view.window, let root = mRootView {
				NSLog("doViewDidAppear")
				let decider = KCFirstResponderDecider(window: window)
				let _ = decider.decideFirstResponder(rootView: root)
				//dumpInfo(phase: "- [doViewDidAppear]", rootView: root)
			} else {
				CNLog(logLevel: .error, message: "No window at \(#function)")
			}
		#endif
	}

	public func updateWindowSize(viewControlEvent event: KCViewControlEvent) {
		if let root = mRootView {
			switch event {
			case .none:
				break
			case .updateWindowSize:
				root.requireLayout()
			}
			//dumpInfo(phase: "updateWindowSize (setNeedsToLayout) ", rootView: root)
		} else {
			NSLog("updateWindowSize ... skipped")
		}
	}

	private func dumpInfo(phase str: String, rootView root: KCRootView) {
		let frame = root.frame
		CNLog(logLevel: .debug, message: "[\(str)] root-frame: \(frame.description)")
	}
}


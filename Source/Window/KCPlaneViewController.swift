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

open class KCPlaneViewController: KCViewController, KCViewControlEventReceiver
{
	private var mRootView:			KCRootView?
	#if os(OSX)
	private var mHasPreferedContentSize:	Bool
	#endif

	public init(){
		mRootView		= nil
		#if os(OSX)
			mHasPreferedContentSize	= false
		#endif
		super.init(nibName: nil, bundle: nil)
	}

	public required init?(coder: NSCoder) {
		mRootView		= nil
		#if os(OSX)
			mHasPreferedContentSize	= false
		#endif
		super.init(coder: coder)
	}

	open override func loadView() {
		//super.loadView() <- Do not call this because it load NIB file (it is NOT exist)
		if mRootView == nil {
			/* Initialize log manager */
			let _ = KCLogWindowManager.shared
			/* Allocate contents by super class */
			let root = KCRootView()
			if let child = loadContext() {
				root.setup(childView: child)
			} else {
				/* Use default root view to tell error */
				let child = errorContext()
				root.setup(childView: child)
			}
			/* Assign as root of this controller*/
			self.view = root
			mRootView = root
		}
	}

	open func loadContext() -> KCView? {
		CNLog(logLevel: .error, message: "Override this method", atFunction: #function, inFile: #file)
		return nil
	}

	open func errorContext() -> KCView {
		CNLog(logLevel: .error, message: "Use error context instead of unacceptable user context")
		let boxview = KCStackView()
		boxview.axis = .vertical

		let msgview = KCTextEdit()
		msgview.isBold	   = false
		msgview.isEditable = false
		msgview.text       = "Failed to load context"
		boxview.addArrangedSubView(subView: msgview)

		return boxview
	}

	open func parentSize() -> CGSize? {
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
			#if os(OSX)
				adjustWindowSize(rootView: root)
			#elseif os(iOS)
				adjustRootViewSize(rootView: root)
			#endif
			if root.hasCoreView {
				/* Layout components */
				CNLog(logLevel: .detail, message: "- [Execute Layout] (root-size=\(root.frame.size.description)")
				let layouter    = KCLayouter()
				layouter.layout(rootView: root)
			}
		} else {
			CNLog(logLevel: .error, message: "No root view")
		}
	}

	#if os(OSX)
	private func adjustWindowSize(rootView root: KCRootView) {
		if mHasPreferedContentSize {
			if let win = root.window {
				win.setContentSize(self.preferredContentSize)
			}
		}
	}
	#endif // os(OSX)

	#if os(iOS)
	private func adjustRootViewSize(rootView root: KCRootView) {
		if let screensize = KCScreen().contentSize {
			root.frame.size  = screensize
			root.bounds.size = screensize
			if let child: KCView = root.getCoreView() {
				child.frame.size  = screensize
				child.bounds.size = screensize
			} else {
				NSLog("No core view")
			}
		} else {
			NSLog("No screen size")
		}
	}
	#endif // os(iOS)

	private func doViewDidLayout() {
		/* Keep prefered size */
		if let root = mRootView {
			#if os(OSX)
				self.preferredContentSize = root.frame.size
				mHasPreferedContentSize   = true
			#endif
		} else {
			CNLog(logLevel: .error, message: "No root view")
		}
	}

	private func doViewDidAppear() {
		#if os(OSX)
			if let window = self.view.window, let root = mRootView {
				/* decide 1st responder */
				let decider = KCFirstResponderDecider(window: window)
				let _ = decider.decideFirstResponder(rootView: root)
			} else {
				CNLog(logLevel: .error, message: "No window at \(#function)")
			}
		#endif
	}

	public func notifyControlEvent(viewControlEvent event: KCViewControlEvent) {
		if let root = mRootView {
			switch event {
			case .none:
				break
			case .updateSize(let targview):
				CNLog(logLevel: .detail, message: "Update window size", atFunction: #function, inFile: #file)
				#if os(OSX)
					mHasPreferedContentSize = false
				#endif
				let invalidator = KCLayoutInvalidator(target: targview)
				root.accept(visitor: invalidator)
				//root.invalidateIntrinsicContentSize()
				//root.requireLayout()
			case .switchFirstResponder(let newview):
				#if os(OSX)
					if let window = self.view.window {
						window.makeFirstResponder(newview)
					} else {
						CNLog(logLevel: .error, message: "Failed to switch first responder", atFunction: #function, inFile: #file)
					}
				#else
					newview.becomeFirstResponder()
				#endif
			}
		} else {
			CNLog(logLevel: .error, message: "No root view", atFunction: #function, inFile: #file)
		}
	}
}


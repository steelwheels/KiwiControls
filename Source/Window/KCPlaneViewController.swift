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

open class KCPlaneViewController: KCViewController, KCWindowDelegate, CNLogging
{
	private var mRootView:			KCRootView? = nil
	private var mConsole:			CNConsole

	#if os(OSX)
	public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
		mRootView	= nil
		mConsole	= KCLogManager.shared.console
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	#else
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		mRootView	= nil
		mConsole	= KCLogManager.shared.console
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	#endif

	public required init?(coder: NSCoder) {
		mRootView	= nil
		mConsole	= KCLogManager.shared.console
		super.init(coder: coder)
	}

	public var console: CNConsole? {
		get { return mConsole }
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

			let root  = KCRootView(console: mConsole)
			root.frame.size  = size
			root.bounds.size = size
			self.view = root
			mRootView = root
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
				let newsize = self.preferredContentSize
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

	public func windowDidResize(parentViewController parent: KCMultiViewController) {
	}

	private func doViewDidAppear(){
		#if os(OSX)
			if let win = self.view.window {
				win.delegate = self
			}
		#endif

		if let root = mRootView {
			if root.hasCoreView {
				let finalizer = KCLayoutFinalizer(console: mConsole)
				finalizer.finalizeLayout(rootView: root)
				/* Make first responder
				 * reference: https://stackoverflow.com/questions/7263482/problems-setting-firstresponder-in-cocoa-mac-osx
				 */
				let maker = KCFirstResponderMaker(console: mConsole)
				if !maker.makeFirstResponder(rootView: root) {
					log(type: .flow, string: "No first responder", file: #file, line: #line, function: #function)
				}
			}
		}
	}

	#if os(OSX)
	public func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
		NSLog("Window resize: \(frameSize.description)")
		return frameSize
	}
	#endif
}


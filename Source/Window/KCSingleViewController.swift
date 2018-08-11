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
	private var mSize:	KCSize
	private var mConsole:	CNConsole
	private var mRootView:	KCRootView? = nil

	public init(size sz: KCSize, console cons: CNConsole){
		mSize 	     = sz
		mConsole     = cons
		super.init(nibName: nil, bundle: nil)
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public var rootView: KCRootView? {
		get { return mRootView }
	}
	
	open override func loadView() {
		let frame = KCRect(origin: KCPoint(x: 0.0, y: 0.0), size: mSize)
		let root  = KCRootView(frame: frame)
		mRootView = root
		self.view = root
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
				let layouter = KCLayouter(console: mConsole)
				layouter.layout(rootView: root, rootSize: mSize)
			} else {
				NSLog("\(#function): Error no core view")
			}

		} else {
			fatalError("No root view")
		}
	}
}



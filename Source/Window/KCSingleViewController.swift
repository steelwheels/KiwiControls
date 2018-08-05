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

open class KCSingleViewDelegate
{
	public init(){
	}
	
	open func viewDidLoad(viewController vcont: KCViewController, rootView rview: KCRootView){
	}

	open func viewWillAppear(viewController vcont: KCViewController, rootView rview: KCRootView){
	}
}

public class KCSingleViewController : KCViewController
{
	private var mDelegate: KCSingleViewDelegate? = nil
	private var mConsole:  CNConsole? = nil

	@IBOutlet weak var mRootView: KCRootView!

	public func setup(delegate dlg: KCSingleViewDelegate, console cons: CNConsole) {
		mDelegate	= dlg
		mConsole	= cons
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		if let d = mDelegate {
			d.viewDidLoad(viewController: self, rootView: mRootView)
		}
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
		if let dlg = mDelegate, let cons = mConsole {
			/* Call delegate */
			dlg.viewWillAppear(viewController: self, rootView: mRootView)

			/* Adjust size */
			let size     = contentsSize()
			let layouter = KCLayouter(console: cons)
			layouter.layout(rootView: mRootView, rootSize: size)
		} else {
			NSLog("KCSingleViewController: [Error] No delegate or console")
		}
	}
}

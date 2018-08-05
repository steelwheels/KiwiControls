/**
 * @file UTSingleViewDelegate.swift
 * @brief Define UTSingleViewDelegate class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import Foundation

public class UTSingleViewDelegate: KCSingleViewDelegate
{
	private var mContentView:	KCView

	public init(contentView cview: KCView){
		mContentView = cview
		super.init()
	}

	public override func viewDidLoad(viewController vcont: KCViewController, rootView root: KCRootView) {
		NSLog("UTSingleViewDelegate.viewDidLoad: 0")
	}

	public override func viewWillAppear(viewController vcont: KCViewController, rootView root: KCRootView) {
		NSLog("UTSingleViewDelegate.viewWillAppear: 0")
		root.setupContext(childView: mContentView)
	}
}


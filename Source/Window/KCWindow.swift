/**
 * @file	KCWindow.swift
 * @brief	Define KCWindow class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import AppKit
import Foundation

public class KCWindow: NSWindow
{	
	@IBOutlet weak var mRootView: KCView!

	public func setRootView(view v: KCView){
		mRootView.addSubview(v)
		mRootView.allocateSubviewLayout(subView: v)
	}
}


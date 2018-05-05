/**
 * @file	KCWindow.swift
 * @brief	Define KCWindow class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)

import AppKit
import Foundation

open class KCWindow: NSWindow
{
	public class func loadWindow(delegate delegateref: KCViewControllerDelegate) -> KCWindow?
	{
		let viewcont = KCViewController.loadViewController(delegate: delegateref)
		return KCWindow(contentViewController: viewcont)
	}
	
	public func setRootView(view v: KCView){
		if let root = self.contentView as? KCView {
			root.addSubview(v)
			root.allocateSubviewLayout(subView: v)
		}
	}
}

#endif


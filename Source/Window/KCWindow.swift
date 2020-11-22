/**
 * @file	KCWindow.swift
 * @brief	Define KCWindow class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

#if os(OSX)
extension NSWindow
{
	public class func loadWindow() -> NSWindow?
	{
		let viewcont = KCViewController.loadViewController(name: "KCEmptyViewController")
		return NSWindow(contentViewController: viewcont)
	}

	public func setRootView(view v: KCView){
		if let root = self.contentView as? KCView {
			root.addSubview(v)
			root.allocateSubviewLayout(subView: v)
		}
	}

	public func resize(size newsize: KCSize){
		NSLog("window resize (before): \(self.frame.size.description)")
		self.setContentSize(newsize)
		NSLog("window resize (after):  \(self.frame.size.description)")
		self.viewsNeedDisplay = true
	}

	public var titleBarHeight: CGFloat {
		get {
			let contentHeight = contentRect(forFrameRect: frame).height
			return frame.height - contentHeight
		}
	}

	public var entireFrame: KCRect {
		get {
			return contentRect(forFrameRect: frame)
		}
	}
}

#endif




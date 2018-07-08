/**
 * @file	KCWindow.swift
 * @brief	Define KCWindow class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

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

	public var titleBarHeight: CGFloat {
		get {
			let contentHeight = contentRect(forFrameRect: frame).height
			return frame.height - contentHeight
		}
	}

	public var rootFrame: KCRect {
		get {
			let preference = KCPreference.shared
			let spacing    = preference.layoutPreference.spacing

			var height    = self.frame.size.height
			var yoff      = CGFloat(0.0)
			let barheight = titleBarHeight
			if height > barheight {
				height -= barheight
			}
			if height > spacing * 2.0 {
				height -= spacing * 2.0
				yoff   = spacing
			}

			var width     = self.frame.size.width
			var xoff      = CGFloat(0.0)
			if width > spacing {
				width  -= spacing
				xoff   =   spacing
			}
			return KCRect(x: xoff, y: yoff, width: width, height: height)
		}
	}
}



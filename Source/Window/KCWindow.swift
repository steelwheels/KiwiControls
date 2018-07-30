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
		let viewcont = KCViewController.loadViewController()
		return NSWindow(contentViewController: viewcont)
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
			let content    = contentRect(forFrameRect: self.frame)

			var height    = content.size.height
			var yoff      = CGFloat(0.0)
			if height > spacing * 2.0 {
				height -= spacing * 2.0
				yoff   =  spacing
			}

			var width     = content.size.width
			var xoff      = CGFloat(0.0)
			if width > spacing {
				width  -= spacing
				xoff   =  spacing
			}
			return KCRect(x: xoff, y: yoff, width: width, height: height)
		}
	}
}
#endif




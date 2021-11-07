/**
 * @file	KCType.swift
 * @brief	Define KCType class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import AppKit
#endif

#if os(iOS)
	public typealias KCPoint		= CGPoint
	public typealias KCSize			= CGSize
	public typealias KCRect			= CGRect
	public typealias KCResponder		= UIResponder
	public typealias KCTextViewDelegate	= UITextViewDelegate
	public typealias KCLayoutAttribute	= NSLayoutConstraint.Attribute
	public typealias KCLayoutRelation	= NSLayoutConstraint.Relation
	public typealias KCLayoutPriority	= UILayoutPriority
	public typealias KCLineBreakMode	= NSLineBreakMode
	public typealias KCLabel		= UILabel
	public typealias KCWindow		= UIWindow
	public typealias KCBezierPath		= UIBezierPath
#else
	public typealias KCPoint		= NSPoint
	public typealias KCSize			= NSSize
	public typealias KCRect			= NSRect
	public typealias KCResponder		= NSResponder
	public typealias KCTextViewDelegate	= NSTextViewDelegate
	public typealias KCLayoutAttribute	= NSLayoutConstraint.Attribute
	public typealias KCLayoutRelation	= NSLayoutConstraint.Relation
	public typealias KCLayoutPriority	= NSLayoutConstraint.Priority
	public typealias KCLineBreakMode	= NSLineBreakMode
	public typealias KCWindowDelegate 	= NSWindowDelegate
	public typealias KCLabel		= NSTextField
	public typealias KCWindow		= NSWindow
	public typealias KCBezierPath		= NSBezierPath
#endif

#if os(OSX)
public extension NSResponder {
	var next: NSResponder? {
		return self.nextResponder
	}
}
#endif

#if os(iOS)
protocol KCWindowDelegate {
	/* Dummy for iOS */
}
#endif

#if os(iOS)
	public typealias KCEdgeInsets		= UIEdgeInsets

	public func KCEdgeInsetsInsetRect(_ rect: CGRect, _ inset: KCEdgeInsets) -> KCRect {
		return rect.inset(by: inset)
	}
#else
	public typealias KCEdgeInsets 		= NSEdgeInsets

	public func KCEdgeInsetsInsetRect(_ rect: CGRect, _ inset: KCEdgeInsets) -> KCRect {
		let inseth:  CGFloat = inset.left + inset.right
		let originx: CGFloat
		let width:   CGFloat
		if inseth <= rect.size.width {
			originx = rect.origin.x + inset.left
			width   = rect.size.width - inseth
		} else {
			originx = rect.origin.x
			width   = rect.size.width
		}

		let insetv:  CGFloat = inset.top + inset.bottom
		let originy: CGFloat
		let height:  CGFloat
		if insetv <= rect.size.height {
			originy = rect.origin.y + inset.top
			height  = rect.size.height - insetv
		} else {
			originy = rect.origin.y
			height  = rect.size.height
		}
		return KCRect(x: originx, y: originy, width: width, height: height)
	}
#endif

public extension KCEdgeInsets {
	var description: String {
		get {
			let l = self.left
			let t = self.top
			let b = self.bottom
			let r = self.right
			return "(left:\(l), top:\(t), bottom:\(b), right:\(r))"
		}
	}
}

public extension KCBezierPath
{
	#if os(OSX)
	func addLine(to pt: CGPoint) {
		self.line(to: pt)
	}
	#else
	func appendRect(_ rt: CGRect){
		let x0 = rt.origin.x
		let y0 = rt.origin.y
		let x1 = x0 + rt.size.width
		let y1 = y0 + rt.size.height
		self.move(to: CGPoint(x: x0, y: y0))
		self.addLine(to: CGPoint(x: x1, y: y0))
		self.addLine(to: CGPoint(x: x1, y: y1))
		self.addLine(to: CGPoint(x: x0, y: y1))
		self.addLine(to: CGPoint(x: x0, y: y0))
	}
	#endif
}


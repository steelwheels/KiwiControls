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
	public typealias KCColor		= UIColor
	public typealias KCFont			= UIFont
	public typealias KCImage		= UIImage
	public typealias KCResponder		= UIResponder
	public typealias KCLayoutAttribute	= NSLayoutConstraint.Attribute
	public typealias KCLayoutRelation	= NSLayoutConstraint.Relation
	public typealias KCLineBreakMode	= NSLineBreakMode
#else
	public typealias KCPoint		= NSPoint
	public typealias KCSize			= NSSize
	public typealias KCRect			= NSRect
	public typealias KCColor		= NSColor
	public typealias KCFont			= NSFont
	public typealias KCImage		= NSImage
	public typealias KCResponder		= NSResponder
	public typealias KCLayoutAttribute	= NSLayoutConstraint.Attribute
	public typealias KCLayoutRelation	= NSLayoutConstraint.Relation
	public typealias KCLineBreakMode	= NSLineBreakMode
#endif

#if os(OSX)
public extension NSResponder {
	public var next: NSResponder? {
		return self.nextResponder
	}
}
#endif

#if os(iOS)
	public typealias KCEdgeInsets		= UIEdgeInsets

	public func KCEdgeInsetsInsetRect(_ rect: CGRect, _ inset: KCEdgeInsets) -> KCRect {
		return rect.inset(by: inset)
	}
#else
	public struct KCEdgeInsets {
		public var top		: CGFloat
		public var left		: CGFloat
		public var bottom	: CGFloat
		public var right	: CGFloat

		public init(top t: CGFloat, left l: CGFloat, bottom b: CGFloat, right r: CGFloat){
			top 	= t
			left	= l
			bottom	= b
			right	= r
		}
	}

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
	public var description: String {
		get {
			let l = self.left
			let t = self.top
			let b = self.bottom
			let r = self.right
			return "(left:\(l), top:\(t), bottom:\(b), right:\(r))"
		}
	}
}

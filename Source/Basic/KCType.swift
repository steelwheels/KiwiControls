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
	public typealias KCLayoutAttribute	= NSLayoutAttribute
	public typealias KCLayoutRelation	= NSLayoutRelation
	public typealias KCLineBreakMode	= NSLineBreakMode
#else
	public typealias KCPoint		= NSPoint
	public typealias KCSize			= NSSize
	public typealias KCRect			= NSRect
	public typealias KCColor		= NSColor
	public typealias KCFont			= NSFont
	public typealias KCImage		= NSImage
	public typealias KCLayoutAttribute	= NSLayoutConstraint.Attribute
	public typealias KCLayoutRelation	= NSLayoutConstraint.Relation
	public typealias KCLineBreakMode	= NSParagraphStyle.LineBreakMode
#endif

public enum KCHorizontalAlignment {
	case top
	case middle
	case bottom

	public var description: String {
		get {
			let result: String
			switch self {
			case .top:	result = "top"
			case .middle:	result = "middle"
			case .bottom:	result = "bottom"
			}
			return result
		}
	}
}

public enum KCVerticalAlignment {
	case leading
	case center
	case trailing

	public var description: String {
		get {
			let result: String
			switch self {
			case .leading:	result = "leading"
			case .center:	result = "center"
			case .trailing:	result = "right"
			}
			return result
		}
	}
}

#if os(iOS)
	public typealias KCEdgeInsets		= UIEdgeInsets
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
#endif

public extension KCRect {
	public func points() -> (CGFloat, CGFloat, CGFloat, CGFloat) { // left, top, right, bottom
		let left   = self.origin.x
		let top    = self.origin.y
		let right  = left + self.size.width
		let bottom = top  + self.size.height
		return (left, top, right, bottom)
	}

	public static func inset(source src: KCRect, in inside: KCRect) -> KCEdgeInsets {
		let (sl, st, sr, sb) = src.points()
		let (il, it, ir, ib) = inside.points()
		let dl = max(il - sl, 0.0)
		let dt = max(it - st, 0.0)
		let dr = max(sr - ir, 0.0)
		let db = max(sb - ib, 0.0)
		return KCEdgeInsets(top: dt, left: dl, bottom: db, right: dr)
	}
}


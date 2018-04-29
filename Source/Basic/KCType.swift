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

public enum Axis {
	case Holizontal
	case Vertical

	public var description: String {
		get {
			let result: String
			switch self {
			case .Holizontal: result = "holizontal"
			case .Vertical:   result = "vertical"
			}
			return result
		}
	}
}

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


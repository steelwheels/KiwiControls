/**
 * @file	KCLine2.swift
 * @brief	Define KCLine2 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct KCLine2
{
	public var fromPoint:	CGPoint
	public var toPoint:	CGPoint
	
	public init(fromPoint: CGPoint, toPoint: CGPoint){
		self.toPoint   = toPoint
		self.fromPoint = fromPoint
	}
	
	public func description() -> String {
		let fromstr = self.fromPoint.description
		let tostr   = self.toPoint.description
		return "(line \(fromstr) -> \(tostr))"
	}
}

public func KCZeroLine2() -> KCLine2 {
	return KCLine2(fromPoint: CGPointZero, toPoint: CGPointZero)
}
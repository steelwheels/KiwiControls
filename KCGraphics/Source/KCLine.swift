/**
 * @file	KCLine.swift
 * @brief	Define KCLine class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct KCLine
{
	public var fromPoint:	CGPoint
	public var toPoint:	CGPoint
	
	public init(fromPoint frompt: CGPoint, toPoint topt: CGPoint){
		self.fromPoint = frompt
		self.toPoint   = topt
	}
	
	public func description() -> String {
		let fromstr = self.fromPoint.description
		let tostr   = self.toPoint.description
		return "(line \(fromstr) -> \(tostr))"
	}
}

public func KCZeroLine() -> KCLine {
	return KCLine(fromPoint: CGPointZero, toPoint: CGPointZero)
}
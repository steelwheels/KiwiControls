/**
 * @file	KCPoint2.swift
 * @brief	Define KCPoint2 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public extension CGPoint {
	public var description: String {
		get {
			return "(\(self.x), \(self.y))"
		}
	}
	
	public func dot(src: CGPoint) -> CGFloat {
		return (self.x * src.x) + (self.y * src.y)
	}
	
	public func cross(src: CGPoint) -> CGFloat {
		return (self.x * src.y) - (self.y * src.x)
	}
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPointMake(left.x + right.x, left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPointMake(left.x - right.x, left.y - right.y)
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPointMake(left.x * right, left.y * right)
}

func * (left: CGFloat, right: CGPoint) -> CGPoint {
	return CGPointMake(left * right.x, left * right.y)
}

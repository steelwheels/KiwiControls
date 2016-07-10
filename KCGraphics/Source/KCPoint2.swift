/**
 * @file	KCPoint2.swift
 * @brief	Define KCPoint2 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public extension CGPoint {
	public func dot(src: CGPoint) -> CGFloat {
		return (self.x * src.x) + (self.y * src.y)
	}

	public func cross(src: CGPoint) -> CGFloat {
		return (self.x * src.y) - (self.y * src.x)
	}

	public func normalize() -> CGPoint {
		let len = sqrt(self.x * self.x + self.y * self.y)
		var result : CGPoint
		if len != 0.0 {
			result = CGPointMake(self.x/len, self.y/len)
		} else {
			result = CGPointMake(0.0, 0.0)
		}
		return result
	}
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPointMake(left.x + right.x, left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPointMake(left.x - right.x, left.y - right.y)
}

public func * (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPointMake(left.x * right, left.y * right)
}

public func * (left: CGFloat, right: CGPoint) -> CGPoint {
	return CGPointMake(left * right.x, left * right.y)
}

public func / (left: CGPoint, right: CGFloat) -> CGPoint {
	return CGPointMake(left.x / right, left.y / right)
}

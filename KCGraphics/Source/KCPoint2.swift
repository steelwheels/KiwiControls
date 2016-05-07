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
}


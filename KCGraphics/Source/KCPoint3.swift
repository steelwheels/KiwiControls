/**
 * @file	KCPoint3.h
 * @brief	Define KCPoint3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct KCPoint3
{
	public var x : CGFloat
	public var y : CGFloat
	public var z : CGFloat
	
	public init(x:CGFloat, y:CGFloat, z:CGFloat){
		self.x = x
		self.y = y
		self.z = z
	}
}

public func KCZeroPoint3() -> KCPoint3 {
	return KCPoint3(x: 0.0, y: 0.0, z: 0.0)
}

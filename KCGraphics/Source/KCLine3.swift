/**
 * @file	KCLine3.h
 * @brief	Define KCLine3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct KCLine3
{
	public var fromPoint:	KCPoint3
	public var toPoint:	KCPoint3
	
	public init(fromPoint: KCPoint3, toPoint: KCPoint3){
		self.toPoint   = toPoint
		self.fromPoint = fromPoint
	}
}

public func KCZeroLine3() -> KCLine3 {
	return KCLine3(fromPoint: KCZeroPoint3(), toPoint:  KCZeroPoint3())
}




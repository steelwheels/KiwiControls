/**
 * @file	KCRect3.h
 * @brief	Define KCRect3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct KCRect3
{
	public var origin:	KCPoint3
	public var size:	KCSize3
	
	public init(origin: KCPoint3, size: KCSize3){
		self.origin = origin
		self.size   = size
	}
}

public func KCZeroRect3() -> KCRect3 {
	return KCRect3(origin: KCZeroPoint3(), size: KCZeroSize3())
}

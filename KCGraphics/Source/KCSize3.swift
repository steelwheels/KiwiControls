/**
 * @file	KCSize3.h
 * @brief	Define KCSize3 class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import CoreGraphics

public struct KCSize3
{
	public var width:	CGFloat		/* X-length */
	public var height:	CGFloat		/* Y-length */
	public var depth:	CGFloat		/* Z-length */
	
	public init(width: CGFloat, height: CGFloat, depth: CGFloat){
		self.width  = width
		self.height = height
		self.depth  = depth
	}
}

public func KCZeroSize3() -> KCSize3 {
	return KCSize3(width: 0.0, height: 0.0, depth: 0.0)
}

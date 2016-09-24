/**
* @file		KCGraphicsLayer.h
* @brief	Define KCGraphicsLayer class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import Foundation
import CoreGraphics

open class KCGraphicsLayer
{
	private var mBounds: CGRect

	public init(bounds b: CGRect){
		mBounds = b
	}

	public var bounds: CGRect {
		get { return mBounds }
	}
	
	public func drawContent(context ctxt:CGContext, bounds bnd:CGRect, dirtyRect drect:CGRect){
	}
}

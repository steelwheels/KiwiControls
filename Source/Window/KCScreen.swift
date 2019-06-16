/**
 * @file	KCScreen.swift
 * @brief	Define KCScreen data structure
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

public class KCScreen
{
	public static var 	shared = KCScreen()
	private var		mScale: CGFloat

	public init(){
		/* scale: point to pixel */
		mScale = KCScreen.initScale()
	}

	private class func initScale() -> CGFloat {
		var result: CGFloat
		#if os(OSX)
			if let screen = NSScreen.main {
				result = screen.backingScaleFactor
			} else {
				NSLog("[Error] No main screen")
				result = 1.0
			}
		#else
			result = UIScreen.main.scale
		#endif
		if result == 0.0 {
			NSLog("[Error] Invalid scale")
			result = 1.0
		}
		return result
	}

	public func pointToPixel(point value: CGFloat) -> CGFloat {
		return value / mScale
	}
}
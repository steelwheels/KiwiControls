/**
 * @file	KCScreen.swift
 * @brief	Define KCScreen data structure
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
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

	public var scale: CGFloat { get { return mScale }}

	public init(){
		/* scale: point to pixel */
		mScale = KCScreen.initScale()
	}

	/* Area for application unit: pixel*/
	public var contentSize: CGSize? {
		#if os(OSX)
			if let screen = NSScreen.main {
				return screen.visibleFrame.size
			} else {
				return nil
			}
		#else
			return UIScreen.main.nativeBounds.size
		#endif
	}

	public func pointToPixel(point value: CGFloat) -> CGFloat {
		return value / mScale
	}

	private class func initScale() -> CGFloat {
		var result: CGFloat
		#if os(OSX)
			if let screen = NSScreen.main {
				result = screen.backingScaleFactor
			} else {
				CNLog(logLevel: .error, message: "No main screen", atFunction: #function, inFile: #file)
				result = 1.0
			}
		#else
			result = UIScreen.main.scale
		#endif
		if result == 0.0 {
			CNLog(logLevel: .error, message: "Invalid scale", atFunction: #function, inFile: #file)
			result = 1.0
		}
		return result
	}

	#if os(iOS)
	public var isPortrait: Bool {
		get {
			if let window = UIApplication.shared.windows.first {
				if let scene = window.windowScene {
					return scene.interfaceOrientation.isPortrait
				}
			}
			return true
		}
	}
	#endif
}

/**
 * @file	KCColor.m
 * @brief	Extend KCColor class
 * @par Copyright
 *   Copyright (C) 2014-2020 Steel Wheels Project
 */

import CoconutData
import Foundation
#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

public extension KCColor
{
	func toRGB() -> (CGFloat, CGFloat, CGFloat) {
		var red 	: CGFloat = 0.0
		var green	: CGFloat = 0.0
		var blue	: CGFloat = 0.0
		var alpha	: CGFloat = 0.0
		#if os(OSX)
			if let color = self.usingColorSpace(.deviceRGB) {
				color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
			} else {
				NSLog("Failed to convert to rgb")
			}
		#else
			self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		#endif
		return (red, green, blue)
	}

	func toTerminalColor() -> CNColor {
		let (red, green, blue) = self.toRGB()
		let rbit : Int32 = red   >= 0.5 ? 1 : 0
		let gbit : Int32 = green >= 0.5 ? 1 : 0
		let bbit : Int32 = blue  >= 0.5 ? 1 : 0
		let rgb  : Int32 = (bbit << 2) | (gbit << 1) | rbit
		if let tcol = CNColor(rawValue: rgb) {
			return tcol
		} else {
			NSLog("Failed to convert to terminal color")
			return CNColor.Black
		}
	}

}

/**
 * @file	KCColorPreference.m
 * @brief	Define KCColorPreference class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

public class KCColorPreference
{
	public struct TextColors {
		public var foreground:	CNColor
		public var background:	CNColor
		public init(foreground f:CNColor, background b:CNColor){
			foreground = f
			background = b
		}
	}

	public struct BackgroundColors {
		public var highlight:	CNColor
		public var normal:	CNColor
		public init(highlight hc: CNColor, normal nc: CNColor){
			highlight = hc
			normal    = nc
		}
	}

	public struct ButtonColors {
		public var title:	CNColor
		public var background:	BackgroundColors
		public init(title t:CNColor, background b:BackgroundColors){
			title      = t
			background = b
		}
	}
}

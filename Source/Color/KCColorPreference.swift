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

public class KCColorPreference
{
	public struct TextColors {
		public var foreground:	KCColor
		public var background:	KCColor
		public init(foreground f:KCColor, background b:KCColor){
			foreground = f
			background = b
		}
	}

	public struct BackgroundColors {
		public var highlight:	KCColor
		public var normal:	KCColor
		public init(highlight hc: KCColor, normal nc: KCColor){
			highlight = hc
			normal    = nc
		}
	}

	public struct ButtonColors {
		public var title:	KCColor
		public var background:	BackgroundColors
		public init(title t:KCColor, background b:BackgroundColors){
			title      = t
			background = b
		}
	}
}

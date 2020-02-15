/**
 * @file	KCPreference.swift
 * @brief	Define KCPreference class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData
import Foundation

public class KCWindowPreference
{
	public var spacing			: CGFloat
	public var backgroundColor		: KCColor
	#if os(OSX)
	public var mainWindowSize		: KCSize?
	#endif

	public init(){
		spacing			= 8.0
		backgroundColor		= KCColor.white
		#if os(OSX)
			mainWindowSize	= nil
		#endif
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

public class KCTerminalPreference: CNPreferenceTable
{
	public typealias CallbackFunction = (_ color: KCColor) -> Void

	public let ForegroundTextColorItem	= "foregroundTextColor"
	public let BackgroundTextColorItem	= "backgroundTextColor"
	public let FontItem			= "font"

	public override init() {
		super.init()
		self.foregroundTextColor	= KCColor.black
		self.backgroundTextColor 	= KCColor.white
		if let newfont = CNFont(name: "Courier", size: 16.0) {
			self.font = newfont
		} else {
			self.font = CNFont.monospacedDigitSystemFont(ofSize: 16.0, weight: .regular)
		}
	}

	public var foregroundTextColor: KCColor? {
		get {
			if let color = super.anyValue(forKey: ForegroundTextColorItem) as? KCColor {
				return color
			} else {
				return nil
			}
		}
		set(newcol) {
			if let col = newcol {
				super.set(anyValue: col, forKey: ForegroundTextColorItem)
			}
		}
	}

	public var backgroundTextColor: KCColor? {
		get {
			if let color = super.anyValue(forKey: BackgroundTextColorItem) as? KCColor {
				return color
			} else {
				return nil
			}
		}
		set(newcol) {
			if let col = newcol {
				super.set(anyValue: col, forKey: BackgroundTextColorItem)
			}
		}
	}

	public var font: CNFont? {
		get {
			if let font = super.anyValue(forKey: FontItem) as? CNFont {
				return font
			} else {
				return nil
			}
		}
		set(newfont) {
			if let font = newfont {
				super.set(anyValue: font, forKey: FontItem)
			}
		}
	}
}

extension CNPreference
{
	public var windowPreference: KCWindowPreference { get {
		return get(name: "window", allocator: {
			() -> KCWindowPreference in return KCWindowPreference()
		})
	}}

	public var terminalPreference: KCTerminalPreference { get {
		return get(name: "terminal", allocator: {
			() -> KCTerminalPreference in return KCTerminalPreference()
		})
	}}
}




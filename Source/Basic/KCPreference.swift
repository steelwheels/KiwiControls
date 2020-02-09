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
	public let TextColorItem		= "textColor"
	public let BackgroundColorItem		= "backgroundColor"
	public let FontItem			= "fontItem"

	public override init() {
		super.init()
		self.textColor		= KCColor.black
		self.backgroundColor 	= KCColor.white
		self.font		= CNFont.monospacedSystemFont(ofSize: 12.0, weight: .regular)
	}

	public var textColor: KCColor? {
		get {
			if let color = super.anyValue(forKey: TextColorItem) as? KCColor {
				return color
			} else {
				return nil
			}
		}
		set(newcol) {
			if let col = newcol {
				super.set(anyValue: col, forKey: TextColorItem)
			}
		}
	}

	public var backgroundColor: KCColor? {
		get {
			if let color = super.anyValue(forKey: BackgroundColorItem) as? KCColor {
				return color
			} else {
				return nil
			}
		}
		set(newcol) {
			if let col = newcol {
				super.set(anyValue: col, forKey: BackgroundColorItem)
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




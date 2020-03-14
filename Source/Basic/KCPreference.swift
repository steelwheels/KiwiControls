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

extension CNPreferenceTable
{
	public func set(colorValue val: KCColor, forKey key: String) {
		set(anyValue: val, forKey: key)
	}

	public func colorValue(forKey key: String) -> KCColor? {
		if let val = anyValue(forKey: key) as? KCColor {
			return val
		} else {
			return nil
		}
	}

	public func storeColorValue(colorValue val: KCColor, forKey key: String) {
		let pathstr = path(keyString: key)
		UserDefaults.standard.set(color: val, forKey: pathstr)
	}

	public func loadColorValue(forKey key: String) -> KCColor? {
		let pathstr = path(keyString: key)
		if let color = UserDefaults.standard.color(forKey: pathstr) {
			return color
		} else {
			return nil
		}
	}
}


public class KCWindowPreference: CNPreferenceTable
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
		super.init(sectionName: "WindowPreference")
	}
}

public class KCTerminalPreference: CNPreferenceTable
{
	public let ColumnNumberItem		= "colmunNumber"
	public let RowNumberItem		= "rowNumber"
	public let ForegroundTextColorItem	= "foregroundTextColor"
	public let BackgroundTextColorItem	= "backgroundTextColor"
	public let FontItem			= "font"

	public init() {
		super.init(sectionName: "TerminalPreference")

		if let num = super.loadIntValue(forKey: ColumnNumberItem) {
			super.set(intValue: num, forKey: ColumnNumberItem)
		} else {
			self.columnNumber = 80
		}

		if let num = super.loadIntValue(forKey: RowNumberItem) {
			super.set(intValue: num, forKey: RowNumberItem)
		} else {
			self.rowNumber = 25
		}

		if let col = super.loadColorValue(forKey: ForegroundTextColorItem) {
			super.set(colorValue: col, forKey: ForegroundTextColorItem)
		} else {
			self.foregroundTextColor = KCColor.black
		}

		if let col = super.loadColorValue(forKey: BackgroundTextColorItem) {
			super.set(colorValue: col, forKey: BackgroundTextColorItem)
		} else {
			self.backgroundTextColor = KCColor.white
		}

		if let newfont = super.loadFontValue(forKey: FontItem) {
			super.set(fontValue: newfont, forKey: FontItem)
		} else {
			if let newfont = CNFont(name: "Courier", size: 14.0) {
				font = newfont
			} else {
				font = CNFont.monospacedDigitSystemFont(ofSize: 14.0, weight: .regular)
			}
		}
	}

	public var columnNumber: Int {
		get {
			if let val = super.intValue(forKey: ColumnNumberItem) {
				return val
			}
			fatalError("Can not happen")
		}
		set(newval) {
			if newval != super.intValue(forKey: ColumnNumberItem) {
				super.storeIntValue(intValue: newval, forKey: ColumnNumberItem)
			}
			super.set(intValue: newval, forKey: ColumnNumberItem)
		}
	}

	public var rowNumber: Int {
		get {
			if let val = super.intValue(forKey: RowNumberItem) {
				return val
			}
			fatalError("Can not happen")
		}
		set(newval) {
			if newval != super.intValue(forKey: RowNumberItem) {
				super.storeIntValue(intValue: newval, forKey: RowNumberItem)
			}
			super.set(intValue: newval, forKey: RowNumberItem)
		}
	}

	public var foregroundTextColor: KCColor {
		get {
			if let color = super.colorValue(forKey: ForegroundTextColorItem) {
				return color
			}
			fatalError("Can not happen")
		}
		set(newcol) {
			super.set(colorValue: newcol, forKey: ForegroundTextColorItem)
			super.storeColorValue(colorValue: newcol, forKey: ForegroundTextColorItem)
		}
	}

	public var backgroundTextColor: KCColor {
		get {
			if let color = super.colorValue(forKey: BackgroundTextColorItem) {
				return color
			}
			fatalError("Can not happen")
		}
		set(newcol) {
			super.set(colorValue: newcol, forKey: BackgroundTextColorItem)
			super.storeColorValue(colorValue: newcol, forKey: BackgroundTextColorItem)
		}
	}

	public var font: CNFont {
		get {
			if let font = super.fontValue(forKey: FontItem) {
				return font
			}
			fatalError("Can not happen")
		}
		set(newfont) {
			super.set(fontValue: newfont, forKey: FontItem)
			super.storeFontValue(fontValue: newfont, forKey: FontItem)
		}
	}
}

extension CNPreference
{
	public var windowPreference: KCWindowPreference { get {
		return get(name: "window", allocator: {
			() -> KCWindowPreference in
				return KCWindowPreference()
		})
	}}

	public var terminalPreference: KCTerminalPreference { get {
		return get(name: "terminal", allocator: {
			() -> KCTerminalPreference in
				return KCTerminalPreference()
		})
	}}
}




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
		_set(anyValue: val, forKey: key)
	}

	public func colorValue(forKey key: String) -> KCColor? {
		if let val = _anyValue(forKey: key) as? KCColor {
			return val
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

	public override init(){
		spacing			= 8.0
		backgroundColor		= KCColor.white
		#if os(OSX)
			mainWindowSize	= nil
		#endif
	}
}

public class KCTerminalPreference: CNPreferenceTable
{
	public let ColumnNumberItem		= "colmunNumber"
	public let RowNumberItem		= "rowNumber"
	public let ForegroundTextColorItem	= "foregroundTextColor"
	public let BackgroundTextColorItem	= "backgroundTextColor"
	public let FontItem			= "font"

	public override init() {
		super.init()
		super.set(intValue: 80, forKey: ColumnNumberItem)
		super.set(intValue: 25, forKey: RowNumberItem)
		super.set(colorValue: KCColor.black, forKey: ForegroundTextColorItem)
		super.set(colorValue: KCColor.white, forKey: BackgroundTextColorItem)
		let font: CNFont
		if let newfont = CNFont(name: "Courier", size: 14.0) {
			font = newfont
		} else {
			font = CNFont.monospacedDigitSystemFont(ofSize: 14.0, weight: .regular)
		}
		super.set(fontValue: font, forKey: FontItem)
	}

	public var columnNumber: Int {
		get {
			if let val = super.intValue(forKey: ColumnNumberItem) {
				return val
			}
			fatalError("Can not happen")
		}
		set(newval) { super.set(intValue: newval, forKey: ColumnNumberItem) }
	}

	public var rowNumber: Int {
		get {
			if let val = super.intValue(forKey: RowNumberItem) {
				return val
			}
			fatalError("Can not happen")
		}
		set(newval) { super.set(intValue: newval, forKey: RowNumberItem) }
	}

	public var foregroundTextColor: KCColor {
		get {
			if let color = super.colorValue(forKey: ForegroundTextColorItem) {
				return color
			}
			fatalError("Can not happen")
		}
		set(newcol) { super.set(colorValue: newcol, forKey: ForegroundTextColorItem) }
	}

	public var backgroundTextColor: KCColor {
		get {
			if let color = super.colorValue(forKey: BackgroundTextColorItem) {
				return color
			}
			fatalError("Can not happen")
		}
		set(newcol) { super.set(colorValue: newcol, forKey: BackgroundTextColorItem) }
	}

	public var font: CNFont {
		get {
			if let font = super.fontValue(forKey: FontItem) {
				return font
			}
			fatalError("Can not happen")
		}
		set(newfont) { super.set(fontValue: newfont, forKey: FontItem) }
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




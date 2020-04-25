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
	public func set(colorValue val: CNColor, forKey key: String) {
		set(anyValue: val, forKey: key)
	}

	public func colorValue(forKey key: String) -> CNColor? {
		if let val = anyValue(forKey: key) as? CNColor {
			return val
		} else {
			return nil
		}
	}

	public func storeColorValue(colorValue val: CNColor, forKey key: String) {
		let pathstr = path(keyString: key)
		UserDefaults.standard.set(color: val, forKey: pathstr)
	}

	public func loadColorValue(forKey key: String) -> CNColor? {
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
	public var backgroundColor		: CNColor
	#if os(OSX)
	public var mainWindowSize		: KCSize?
	#endif

	public init(){
		spacing			= 8.0
		backgroundColor		= CNColor.white
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

		if let coldict = super.loadColorDictionaryValue(forKey: ForegroundTextColorItem) {
			super.set(colorDictionaryValue: coldict, forKey: ForegroundTextColorItem)
		} else {
			let coldict: Dictionary<CNInterfaceStyle, CNColor> = [:]
			super.set(colorDictionaryValue: coldict, forKey: ForegroundTextColorItem)
		}

		if let coldict = super.loadColorDictionaryValue(forKey: BackgroundTextColorItem) {
			super.set(colorDictionaryValue: coldict, forKey: BackgroundTextColorItem)
		} else {
			let coldict: Dictionary<CNInterfaceStyle, CNColor> = [:]
			super.set(colorDictionaryValue: coldict, forKey: BackgroundTextColorItem)
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

	public var foregroundTextColor: CNColor {
		get {
			if let color = self.getColor(itemName: ForegroundTextColorItem) {
				return color
			} else {
				let result: CNColor
				switch CNPreference.shared.systemPreference.interfaceStyle {
				case .dark:	result = CNColor.white
				case .light:	result = CNColor.black
				}
				self.saveColor(itemName: ForegroundTextColorItem, color: result)
				return result
			}
		}
		set(newcol) {
			self.saveColor(itemName: ForegroundTextColorItem, color: newcol)
		}
	}

	public var backgroundTextColor: CNColor {
		get {
			if let color = self.getColor(itemName: BackgroundTextColorItem) {
				return color
			} else {
				let result: CNColor
				switch CNPreference.shared.systemPreference.interfaceStyle {
				case .dark:	result = CNColor.black
				case .light:	result = CNColor.white
				}
				self.saveColor(itemName: BackgroundTextColorItem, color: result)
				return result
			}
		}
		set(newcol) {
			self.saveColor(itemName: BackgroundTextColorItem, color: newcol)
		}
	}

	private func getColor(itemName name: String) -> CNColor? {
		let style = CNPreference.shared.systemPreference.interfaceStyle
		if let dict = super.colorDictionaryValue(forKey: name) {
			if let color = dict[style] {
				return color
			}
		}
		return nil
	}

	private func saveColor(itemName name: String, color col: CNColor) {
		let style = CNPreference.shared.systemPreference.interfaceStyle
		if var dict = super.colorDictionaryValue(forKey: name) {
			dict[style] = col
			super.set(colorDictionaryValue: dict, forKey: name)
			super.storeColorDictionaryValue(dataDictionaryValue: dict, forKey: name)
		} else {
			let dict: Dictionary<CNInterfaceStyle, CNColor> = [style:col]
			super.set(colorDictionaryValue: dict, forKey: name)
			super.storeColorDictionaryValue(dataDictionaryValue: dict, forKey: name)
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




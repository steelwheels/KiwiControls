/**
 * @file	KCAttributedString.swift
 * @brief	Define KCAttributedString class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public enum KCStringAttribute {
	case font(CNFont)
	case foregroundColor(CNColor)
	case backgroundColor(CNColor)
}

private class KCStringAttributes {
	private var mAttributes:	Dictionary<NSAttributedString.Key, Any>

	public var attributes: Dictionary<NSAttributedString.Key, Any> {
		get { return mAttributes }
	}

	public init() {
		mAttributes = [:]
	}

	public func set(attributes attrs: [KCStringAttribute]){
		for attr in attrs {
			set(attribute: attr)
		}
	}

	public func set(attribute attr: KCStringAttribute){
		switch attr {
		case .font(let font):
			mAttributes[NSAttributedString.Key.font] = font
		case .foregroundColor(let color):
			mAttributes[NSAttributedString.Key.foregroundColor] = color
		case .backgroundColor(let color):
			mAttributes[NSAttributedString.Key.backgroundColor] = color
		}
	}
}

public extension NSAttributedString {
	convenience init(string str: String, stringAttributes attrs: [KCStringAttribute]){
		let attrobj = KCStringAttributes()
		attrobj.set(attributes: attrs)
		self.init(string: str, attributes: attrobj.attributes)
	}
}

public extension NSMutableAttributedString
{
	func changeOverallTextColor(targetColor curcol: CNColor, newColor newcol: CNColor){
		self.beginEditing()
		let entire = NSMakeRange(0, self.length)
		self.enumerateAttribute(.foregroundColor, in: entire, options: [], using: {
			(anyobj, range, unsage) -> Void in
			/* Replace current foreground color attribute by new color */
			if let colobj = anyobj as? CNColor {
				if colobj.isEqual(curcol) {
					removeAttribute(.foregroundColor, range: range)
					addAttribute(.foregroundColor, value: newcol, range: range)
				}
			}
		})
		self.endEditing()
	}

	func changeOverallBackgroundColor(targetColor curcol: CNColor, newColor newcol: CNColor){
		self.beginEditing()
		let entire = NSMakeRange(0, self.length)
		self.enumerateAttribute(.backgroundColor, in: entire, options: [], using: {
			(anyobj, range, unsage) -> Void in
			/* Replace current background color attribute by new color */
			if let colobj = anyobj as? CNColor {
				if colobj.isEqual(curcol) {
					removeAttribute(.backgroundColor, range: range)
					addAttribute(.backgroundColor, value: newcol, range: range)
				}
			}
		})
		self.endEditing()
	}
}


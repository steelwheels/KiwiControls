/**
 * @file	KCAttributedString.swift
 * @brief	Define KCAttributedString class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import Foundation

public enum KCStringAttribute {
	case font(KCFont)
	case foregroundColor(KCColor)
	case backgroundColor(KCColor)
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

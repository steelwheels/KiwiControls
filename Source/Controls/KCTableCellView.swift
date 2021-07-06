/**
 * @file	KCTableCellView.swift
 * @brief	Define KCTableCellView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)

import CoconutData
import Foundation
import Cocoa


public class KCTableCellView: NSTableCellView
{
	public var isEditable: Bool = false

	public override var objectValue: Any? {
		get {
			return super.objectValue
		}
		set(newval){
			if let nval = newval as? CNNativeValue {
				updateValue(value: nval)
			}
			super.objectValue = newval
		}
	}

	private func updateValue(value val: CNNativeValue){
		switch val {
		case .nullValue:
			updateStringValue(value: "")
		case .numberValue(let num):
			updateStringValue(value: num.stringValue)
		case .stringValue(let str):
			updateStringValue(value: str)
		case .dateValue(let date):
			updateStringValue(value: date.description)
		case .rangeValue(let range):
			updateStringValue(value: "{location=\(range.location), length=\(range.length)}")
		case .pointValue(let pt):
			updateStringValue(value: pt.description)
		case .sizeValue(let sz):
			updateStringValue(value: sz.description)
		case .rectValue(let rect):
			updateStringValue(value: rect.description)
		case .enumValue(let name, let num):
			updateStringValue(value: ".\(name)(\(num)")
		case .dictionaryValue(_):
			let str = val.toText().toStrings().joined()
			updateStringValue(value: str)
		case .arrayValue(_):
			let str = val.toText().toStrings().joined()
			updateStringValue(value: str)
		case .URLValue(let url):
			updateStringValue(value: url.path)
		case .colorValue(let col):
			updateStringValue(value: col.rgbName)
		case .imageValue(let img):
			updateImageValue(value: img)
		case .objectValue(let obj):
			let str = "\(obj.description)"
			updateStringValue(value: str)
		@unknown default:
			NSLog("Unknown type value")
		}
	}

	private func updateStringValue(value val: String){
		if let field = super.textField {
			field.stringValue = val
			field.isEditable  = self.isEditable
			field.sizeToFit()
		} else {
			let newfield = NSTextField(string: val)
			super.textField = newfield
		}
	}

	private func updateImageValue(value val: CNImage){
		if let imgview = super.imageView {
			imgview.image = val
		} else {
			let newimage = NSImageView()
			newimage.image = val
			super.imageView = newimage
		}
	}

	public var firstResponderView: KCViewBase? { get {
		if let field = self.textField {
			return field
		} else if let imgview = self.imageView {
			return imgview
		} else {
			return nil
		}
	}}
	
	public override var intrinsicContentSize: NSSize {
		get {
			if let field = self.textField {
				return field.intrinsicContentSize
			} else if let img = self.imageView {
				return img.intrinsicContentSize
			} else {
				return super.intrinsicContentSize
			}
		}
	}
}

#endif // os(OSX)


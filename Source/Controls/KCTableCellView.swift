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
			field.sizeToFit()
			NSLog("updateStringValue: size=\(field.frame.size.description)")
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

	public var isEditable: Bool {
		get {
			if let field = self.textField {
				return field.isEditable
			} else if let _ = self.imageView {
				return false
			} else {
				return false
			}
		}
		set(newval){
			if let field = self.textField {
				field.isEditable = newval
			} else if let _ = self.imageView {
				// do nothing
			} else {
				// do nothing
			}
		}
	}

	public var isEnabled: Bool {
		get {
			if let field = self.textField {
				return field.isEnabled
			} else if let img = self.imageView {
				return img.isEnabled
			} else {
				return false
			}
		}
		set(newval){
			if let field = self.textField {
				field.isEnabled = newval
			} else if let img = self.imageView {
				img.isEnabled = newval
			} else {
				// do nothing
			}
		}
	}

	public override var intrinsicContentSize: NSSize {
		get {
			if let field = self.textField {
				return self.intrinsicContentSize(ofTextField: field)
			} else if let img = self.imageView {
				return img.intrinsicContentSize
			} else {
				return super.intrinsicContentSize
			}
		}
	}

	private func intrinsicContentSize(ofTextField field: NSTextField) -> KCSize {
		let DefaultLength: Int = 20

		let curnum = field.stringValue.count
		let newnum = max(curnum, DefaultLength)

		let fitsize = field.fittingSize

		let newwidth: CGFloat
		if let font = field.font {
			let attr = [NSAttributedString.Key.font: font]
			let str: String = " "
			let fsize = str.size(withAttributes: attr)
			newwidth = max(fitsize.width, fsize.width * CGFloat(newnum))
		} else {
			newwidth = fitsize.width
		}

		field.preferredMaxLayoutWidth = newwidth
		return KCSize(width: newwidth, height: fitsize.height)
	}

	public override var fittingSize: KCSize {
		get {
			if let field = self.textField {
				return field.fittingSize
			} else if let img = self.imageView {
				return img.fittingSize
			} else {
				return super.fittingSize
			}
		}
	}

	public override func setFrameSize(_ newsize: KCSize) {
		NSLog("KCTableCellView: setFrameSize(\(newsize.description)")
		let fitsize = self.fittingSize
		if fitsize.width <= newsize.width && fitsize.height <= newsize.height {
			self.setFrameSizeBody(size: newsize)
		} else {
			NSLog("Failed to setFrameSize: Given size is too small: \(fitsize.description)")
			self.setFrameSizeBody(size: fitsize)
		}
	}

	private func setFrameSizeBody(size newsize: KCSize){
		super.setFrameSize(newsize)
		if let field = self.textField {
			field.setFrameSize(newsize)
		} else if let img = self.imageView {
			img.setFrameSize(newsize)
		}
	}
}

#endif // os(OSX)


/**
 * @file	KCValueView.swift
 * @brief	Define KCValueView class
 * @par Copyright
 *   Copyright (C) 2021  Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

open class KCValueView: KCStackView
{
	private var mValue: CNNativeValue = .nullValue

	public var value: CNNativeValue { get { return  mValue }}

	public func load(value val: CNNativeValue){
		if let view = valueToView(value: val){
			self.removeAllArrangedSubiews()
			self.addArrangedSubView(subView: view)
			mValue = val
			NSLog("request layout")
			self.invalidateIntrinsicContentSize()
			self.requireLayout()
			self.requireDisplay()
		}
	}

	private func valueToView(value val: CNNativeValue) -> KCView? {
		var result: KCView? = nil
		switch val {
		case .nullValue:
			result = nil
		case .boolValue(_), .numberValue(_), .stringValue(_), .dateValue(_), .URLValue(_), .colorValue(_):
			if let view = scalerValueToView(value: val) {
				result = view
			}
		case .rangeValue(let range):
			let dict: Dictionary<String, CNNativeValue> = [
				"location": .numberValue(NSNumber(integerLiteral: range.location)),
				"length":   .numberValue(NSNumber(integerLiteral: range.length))
			]
			if let view = dictionaryValueToView(dictionary: dict){
				result = view
			}
		case .pointValue(let point):
			let dict: Dictionary<String, CNNativeValue> = [
				"x": .numberValue(NSNumber(floatLiteral: Double(point.x))),
				"y": .numberValue(NSNumber(floatLiteral: Double(point.y)))
			]
			if let view = dictionaryValueToView(dictionary: dict){
				result = view
			}
		case .sizeValue(let size):
			let dict: Dictionary<String, CNNativeValue> = [
				"width":  .numberValue(NSNumber(floatLiteral: Double(size.width))),
				"height": .numberValue(NSNumber(floatLiteral: Double(size.height)))
			]
			if let view = dictionaryValueToView(dictionary: dict){
				result = view
			}
		case .enumValue(let name, let ival):
			let dict: Dictionary<String, CNNativeValue> = [
				name: .numberValue(NSNumber(integerLiteral: Int(ival)))
			]
			if let view = dictionaryValueToView(dictionary: dict){
				result = view
			}
		case .rectValue(let rect):
			let dict: Dictionary<String, CNNativeValue> = [
				"x":	  .numberValue(NSNumber(floatLiteral: Double(rect.origin.x))),
				"y":	  .numberValue(NSNumber(floatLiteral: Double(rect.origin.y))),
				"width":  .numberValue(NSNumber(floatLiteral: Double(rect.size.width))),
				"height": .numberValue(NSNumber(floatLiteral: Double(rect.size.height)))
			]
			if let view = dictionaryValueToView(dictionary: dict){
				result = view
			}
		case .imageValue(let img):
			if let view = imageValueToView(value: img) {
				result = view
			}
		case .dictionaryValue(let dict):
			if let view = dictionaryValueToView(dictionary: dict){
				result = view
			} else if let view = labeledValueToView(dictionary: dict) {
				result = view
			}
		case .arrayValue(let arr):
			if let view = arrayValueToView(array: arr){
				result = view
			}
		case .objectValue(let obj):
			if let view = stringValueToView(value: "\(obj)") {
				result = view
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Undefined type", atFunction: #function, inFile: #file)
		}
		return result
	}

	private func dictionaryValueToView(dictionary dict: Dictionary<String, CNNativeValue>) -> KCView? {
		let table = CNNativeValueTable()
		for (key, elm) in dict {
			switch elm {
			case .stringValue(let val):
				let record = CNValueRecord()
				let _ = record.setValue(value: .stringValue(key), forField: "key")
				let _ = record.setValue(value: .stringValue(val), forField: "value")
				table.append(record: record)
			default:
				return nil // not supported element
			}
		}
		let newview = KCTableView()
		newview.load(table: table)
		return newview
	}

	private func arrayValueToView(array arr: Array<CNNativeValue>) -> KCView? {
		let newview = KCStackView()
		for elm in arr {
			if let eview = valueToView(value: elm) {
				newview.addArrangedSubView(subView: eview)
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate view", atFunction: #function, inFile: #file)
			}
		}
		return newview
	}

	private func labeledValueToView(dictionary dict: Dictionary<String, CNNativeValue>) -> KCView? {
		let newview = KCStackView()
		for (key, elm) in dict {
			let labview = KCLabeledStackView()
			labview.title = key
			if let elmview = valueToView(value: elm) {
				labview.addArrangedSubView(subView: elmview)
			} else {
				CNLog(logLevel: .error, message: "Failed to allocate element", atFunction: #function, inFile: #file)
			}
			newview.addArrangedSubView(subView: labview)
		}
		return newview
	}

	private func scalerValueToView(value val: CNNativeValue) -> KCView? {
		let result: KCView?
		switch val {
		case .stringValue(let str):
			result = stringValueToView(value: str)
		case .boolValue(let val):
			result = stringValueToView(value: "\(val)")
		case .numberValue(let num):
			result = stringValueToView(value: num.stringValue)
		case .dateValue(let date):
			let format = DateFormatter()
			format.dateFormat = "YYYY-MM-dd hh:mm:ss"
			result = stringValueToView(value: format.string(from: date))
		case .URLValue(let url):
			result = stringValueToView(value: url.path)
		case .colorValue(let color):
			result = stringValueToView(value: color.rgbName)
		default:
			result = nil
		}
		return result
	}

	private func stringValueToView(value val: String) -> KCView? {
		let newview = KCTextEdit()
		newview.text = val
		return newview
	}

	private func imageValueToView(value val: CNImage) -> KCView? {
		let newview = KCImageView()
		newview.set(image: val)
		return newview
	}
}

/**
 * @file KCStackView.swift
 * @brief Define KCStackView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCValueView : KCStackView
{
	private var mBaseValue: CNValue = .nullValue

	public var value: CNValue {
		get {
			return loadValue(baseValue: mBaseValue, parent: self, index: 0)
		}
		set(val){
			super.removeAllArrangedSubviews()
			storeValue(value: val, parent: self)
		}
	}

	private func storeValue(value val: CNValue, parent parview: KCStackView){
		switch val {
		case .nullValue:
			break
		case .boolValue(let val):
			storeString(value: "\(val)", parent: parview)
		case .numberValue(let val):
			storeString(value: val.stringValue, parent: parview)
		case .stringValue(let val):
			storeString(value: val, parent: parview)
		case .dateValue(let val):
			storeString(value: stringFromDate(date: val), parent: parview)
		case .rangeValue(let val):
			let dict: Dictionary<String, CNValue> = [
				"location":	intToValue(source: val.location),
				"length":	intToValue(source: val.length)
			]
			storeDictionary(value: dict, parent: parview)
		case .pointValue(let val):
			let dict: Dictionary<String, CNValue> = [
				"x":		floatToValue(source: val.x),
				"y":		floatToValue(source: val.y)
			]
			storeDictionary(value: dict, parent: parview)
		case .sizeValue(let val):
			let dict: Dictionary<String, CNValue> = [
				"width":	floatToValue(source: val.width),
				"height":	floatToValue(source: val.height)
			]
			storeDictionary(value: dict, parent: parview)
		case .rectValue(let val):
			let dict: Dictionary<String, CNValue> = [
				"x":		floatToValue(source: val.origin.x),
				"y":		floatToValue(source: val.origin.y),
				"width":	floatToValue(source: val.size.width),
				"height":	floatToValue(source: val.size.height)
			]
			storeDictionary(value: dict, parent: parview)
		case .enumValue(let type, let id):
			let dict: Dictionary<String, CNValue> = [
				"type":		.stringValue(type),
				"id":		intToValue(source: Int(id))
			]
			storeDictionary(value: dict, parent: parview)
		case .dictionaryValue(let val):
			storeDictionary(value: val, parent: parview)
		case .arrayValue(let val):
			storeArray(value: val, parent: parview)
		case .URLValue(let val):
			storeString(value: val.path, parent: parview)
		case .colorValue(let val):
			storeString(value: val.rgbName, parent: parview)
		case .imageValue(let val):
			storeImage(value: val, parent: parview)
		case .objectValue(let val):
			storeString(value: "\(val.description)", parent: parview)
		@unknown default:
			break
		}
	}

	private func loadValue(baseValue base: CNValue, parent parview: KCStackView, index idx: Int) -> CNValue {
		var result: CNValue = .nullValue
		switch base {
		case .nullValue:
			break
		case .boolValue(_):
			if let str = loadString(parent: parview, index: idx){
				if let val = stringToBool(source: str) {
					result = .boolValue(val)
				}
			}
		case .numberValue(_):
			if let str = loadString(parent: parview, index: idx){
				let formatter = NumberFormatter()
				if let num = formatter.number(from: str) {
					result = .numberValue(num)
				}
			}
		case .stringValue(_):
			if let str = loadString(parent: parview, index: idx){
				result = .stringValue(str)
			}
		case .dateValue(_):
			if let str = loadString(parent: parview, index: idx){
				if let val = dateFromString(string: str) {
					result = .dateValue(val)
				}
			}
		case .rangeValue(_):
			if let dict = loadDictionary(parent: parview, index: idx){
				if let locval = dict["location"], let lenval = dict["length"] {
					if let locnum = locval.toNumber(), let lennum = lenval.toNumber() {
						let range = NSRange(location: locnum.intValue, length: lennum.intValue)
						result = .rangeValue(range)
					}
				}
			}
		case .pointValue(_):
			if let dict = loadDictionary(parent: parview, index: idx){
				if let xval = dict["x"], let yval = dict["y"] {
					if let xnum = xval.toNumber(), let ynum = yval.toNumber() {
						let point = CGPoint(x: xnum.doubleValue, y: ynum.doubleValue)
						result = .pointValue(point)
					}
				}
			}
		case .sizeValue(_):
			if let dict = loadDictionary(parent: parview, index: idx){
				if let widthval = dict["width"], let heightval = dict["height"] {
					if let widthnum = widthval.toNumber(), let heightnum = heightval.toNumber() {
						let size = CGSize(width: widthnum.doubleValue, height: heightnum.doubleValue)
						result = .sizeValue(size)
					}
				}
			}
		case .rectValue(_):
			if let dict = loadDictionary(parent: parview, index: idx){
				if let xval = dict["x"], let yval = dict["y"], let widthval = dict["width"], let heightval = dict["height"] {
					if let xnum = xval.toNumber(), let ynum = yval.toNumber(), let widthnum = widthval.toNumber(), let heightnum = heightval.toNumber() {
						let origin = CGPoint(x: xnum.doubleValue, y: ynum.doubleValue)
						let size   = CGSize(width: widthnum.doubleValue, height: heightnum.doubleValue)
						result = .rectValue(CGRect(origin: origin, size: size))
					}
				}
			}
		case .enumValue(_, _):
			if let dict = loadDictionary(parent: parview, index: idx){
				if let typeval = dict["type"], let idval = dict["id"] {
					if let typestr = typeval.toString(), let idnum = idval.toNumber() {
						result = .enumValue(typestr, Int32(idnum.intValue))
					}
				}
			}
		case .dictionaryValue(_):
			if let dict = loadDictionary(parent: parview, index: idx){
				result = .dictionaryValue(dict)
			}
		case .arrayValue(let basearr):
			var newarr: Array<CNValue> = []
			let elmnum = basearr.count
			for i in 0..<elmnum {
				let elm = loadValue(baseValue: basearr[i], parent: parview, index: idx + i)
				newarr.append(elm)
			}
			result = .arrayValue(newarr)
		case .URLValue(_):
			if let str = loadString(parent: parview, index: idx){
				let url = URL(fileURLWithPath: str)
				result = .URLValue(url)
			}
		case .colorValue(_):
			CNLog(logLevel: .error, message: "Not supported", atFunction: #function, inFile: #file)
		case .imageValue(_):
			if let img = loadImage(parent: parview, index: idx){
				result = .imageValue(img)
			}
		case .objectValue(_):
			CNLog(logLevel: .error, message: "Not supported", atFunction: #function, inFile: #file)
		@unknown default:
			CNLog(logLevel: .error, message: "Undefined type", atFunction: #function, inFile: #file)
		}
		return result
	}

	private func stringToBool(source src: String) -> Bool? {
		let result: Bool?
		if src.caseInsensitiveCompare("true") == .orderedSame {
			result = true
		} else if src.caseInsensitiveCompare("false") == .orderedSame {
			result = false
		} else {
			result = nil
		}
		return result
	}

	private func intToValue(source src: Int) -> CNValue {
		let num = NSNumber(value: src)
		return .numberValue(num)
	}

	private func floatToValue(source src: CGFloat) -> CNValue {
		let num = NSNumber(value: Double(src))
		return .numberValue(num)
	}

	private func storeString(value val: String, parent parview: KCStackView){
		let view = KCTextEdit()
		view.text       = val
		view.isEditable = false
		parview.addArrangedSubView(subView: view)
	}

	private func loadString(parent parview: KCStackView, index idx: Int) -> String? {
		let subviews = parview.arrangedSubviews()
		if 0<=idx && idx<subviews.count {
			if let subview = subviews[idx] as? KCTextEdit {
				return subview.text
			}
		}
		return nil
	}

	private func storeDictionary(value val: Dictionary<String, CNValue>, parent parview: KCStackView){
		if hasScalerValues(dictionary: val) {
			let table = KCTableView()
			table.store(dictionary: val)
			parview.addArrangedSubView(subView: table)
		} else {
			let keys = val.keys.sorted()
			for key in keys {
				if let elm = val[key] {
					let labview = KCLabeledStackView()
					labview.title = key
					parview.addArrangedSubView(subView: labview)
					/* Allocate element */
					storeValue(value: elm, parent: labview.contentsView)
				}
			}
		}
	}

	private func loadDictionary(parent parview: KCStackView, index idx: Int) -> Dictionary<String, CNValue>? {
		let subviews = parview.arrangedSubviews()
		if 0<=idx && idx<subviews.count {
			if let tabview = subviews[idx] as? KCTableView {
				//return subview.image
			}
		}
		return nil
	}

	private func storeArray(value val: Array<CNValue>, parent parview: KCStackView){
		for elm in val {
			storeValue(value: elm, parent: parview)
		}
	}

	private func loadImage(parent parview: KCStackView, index idx: Int) -> CNImage? {
		let subviews = parview.arrangedSubviews()
		if 0<=idx && idx<subviews.count {
			if let subview = subviews[idx] as? KCImageView {
				return subview.image
			}
		}
		return nil
	}

	private func storeImage(value val: CNImage, parent parview: KCStackView){
		let view = KCImageView()
		view.image = val
		parview.addArrangedSubView(subView: view)
	}

	private func stringFromDate(date: Date) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
		return formatter.string(from: date)
	}

	private func dateFromString(string: String) -> Date? {
		let formatter: DateFormatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
		return formatter.date(from: string)
	}

	private func hasScalerValues(dictionary dict: Dictionary<String, CNValue>) -> Bool {
		for (_, val) in dict {
			if !isScaler(value: val){
				return false
			}
		}
		return true
	}

	private func isScaler(value val: CNValue) -> Bool {
		let result: Bool
		switch val {
		case .nullValue, .boolValue(_), .numberValue(_), .stringValue(_),
		     .dateValue(_), .enumValue(_, _), .URLValue(_), .colorValue(_):
			result = true
		case .rangeValue(_), .pointValue(_), .sizeValue(_), .rectValue(_),
		     .dictionaryValue(_), .arrayValue(_), .imageValue(_), .objectValue(_):
			result = false
		@unknown default:
			CNLog(logLevel: .error, message: "Undefined value type", atFunction: #function, inFile: #file)
			result = false
		}
		return result
	}
}


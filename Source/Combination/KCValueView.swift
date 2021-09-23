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
	public func load(value val: CNValue){
		super.removeAllArrangedSubviews()
		loadValue(value: val, parent: self)
	}

	private func loadValue(value val: CNValue, parent parview: KCStackView){
		switch val {
		case .nullValue:
			break
		case .boolValue(let val):
			loadString(value: "\(val)", parent: parview)
		case .numberValue(let val):
			loadString(value: val.stringValue, parent: parview)
		case .stringValue(let val):
			loadString(value: val, parent: parview)
		case .dateValue(let val):
			loadString(value: stringFromDate(date: val), parent: parview)
		case .rangeValue(let val):
			let location = NSNumber(value: val.location)
			let length   = NSNumber(value: val.length)
			let dict: Dictionary<String, CNValue> = [
				"location": .numberValue(location),
				"length":   .numberValue(length)
			]
			loadDictionary(value: dict, parent: parview)
		case .pointValue(let val):
			let x = NSNumber(value: Float(val.x))
			let y = NSNumber(value: Float(val.y))
			let dict: Dictionary<String, CNValue> = [
				"x": .numberValue(x),
				"y": .numberValue(y)
			]
			loadDictionary(value: dict, parent: parview)
		case .sizeValue(let val):
			let width  = NSNumber(value: Float(val.width))
			let height = NSNumber(value: Float(val.height))
			let dict: Dictionary<String, CNValue> = [
				"width":  .numberValue(width),
				"height": .numberValue(height)
			]
			loadDictionary(value: dict, parent: parview)
		case .rectValue(let val):
			let origin: CNValue = .pointValue(val.origin)
			let size:   CNValue = .sizeValue(val.size)
			let dict: Dictionary<String, CNValue> = [
				"origin":  origin,
				"size":    size
			]
			loadDictionary(value: dict, parent: parview)
		case .enumValue(let type, let name):
			loadString(value: "\(type)/\(name)", parent: parview)
		case .dictionaryValue(let val):
			loadDictionary(value: val, parent: parview)
		case .arrayValue(let val):
			loadArray(value: val, parent: parview)
		case .URLValue(let val):
			loadString(value: val.path, parent: parview)
		case .colorValue(let val):
			loadString(value: val.rgbName, parent: parview)
		case .imageValue(let val):
			loadImage(value: val, parent: parview)
		case .objectValue(let val):
			loadString(value: "\(val.description)", parent: parview)
		@unknown default:
			break
		}
	}

	private func loadString(value val: String, parent parview: KCStackView){
		let view = KCTextEdit()
		view.text       = val
		view.isEditable = false
		parview.addArrangedSubView(subView: view)
	}

	private func loadDictionary(value val: Dictionary<String, CNValue>, parent parview: KCStackView){
		if hasScalerValues(dictionary: val) {
			let table = KCTableView()
			table.load(table: KCDictionaryTableBridge(dictionary: val))
			parview.addArrangedSubView(subView: table)
		} else {
			let keys = val.keys.sorted()
			for key in keys {
				if let elm = val[key] {
					let labview = KCLabeledStackView()
					labview.title = key
					parview.addArrangedSubView(subView: labview)
					/* Allocate element */
					loadValue(value: elm, parent: labview.contentsView)
				}
			}
		}
	}

	private func loadArray(value val: Array<CNValue>, parent parview: KCStackView){
		for elm in val {
			loadValue(value: elm, parent: parview)
		}
	}

	private func loadImage(value val: CNImage, parent parview: KCStackView){
		let view = KCImageView()
		view.set(image: val)
		parview.addArrangedSubView(subView: view)
	}

	private func stringFromDate(date: Date) -> String {
		let formatter: DateFormatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .gregorian)
		formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
		return formatter.string(from: date)
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


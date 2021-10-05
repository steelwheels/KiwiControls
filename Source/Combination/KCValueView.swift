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

public protocol KCValueViewInterface
{
	var value: CNValue { get set }
}

private func requireUpdate(view v: KCView){
	v.invalidateIntrinsicContentSize()
	v.requireLayout()
}

public class KCScalarValueView: KCTextEdit, KCValueViewInterface
{
	public typealias Format = KCTextEditCore.Format

	private var mValueType: CNValueType = .stringType

	public var value: CNValue {
		get {
			if let val = CNValue.stringToValue(type: mValueType, source: self.text) {
				return val
			} else {
				return .nullValue
			}
		}
		set(newval){
			let format: Format
			switch newval {
			case .numberValue(_):	format = .number
			default:		format = .text
			}
			let str = newval.toText().toStrings().joined(separator: "\n")
			self.format = format
			self.text   = str
			requireUpdate(view: self)
		}
	}
}

public class KCDictionaryValueView: KCTableView, KCValueViewInterface
{
	public var value: CNValue {
		get {
			if let dict = self.loadDictionary() {
				return CNValue.dictionaryToValue(dictionary: dict)
			} else {
				return .nullValue
			}
		}
		set(newval){
			if let dict = CNValue.valueToDictionary(value: newval) {
				self.store(dictionary: dict)
			} else {
				CNLog(logLevel: .error, message: "Failed to set value", atFunction: #function, inFile: #file)
			}
			requireUpdate(view: self)
		}
	}
}

public class KCArrayValueView: KCStackView, KCValueViewInterface
{
	public var value: CNValue {
		get {
			var result: Array<CNValue> = []
			for subview in self.arrangedSubviews() {
				if let viewif = subview as? KCValueViewInterface {
					result.append(viewif.value)
				}
			}
			return .arrayValue(result)
		}
		set(newval){
			if let arr = newval.toArray() {
				self.removeAllArrangedSubviews()
				for elm in arr {
					KCValueView.valueToView(value: elm, parent: self)
				}
			} else {
				CNLog(logLevel: .error, message: "Not array value", atFunction: #function, inFile: #file)
			}
			requireUpdate(view: self)
		}
	}
}

public class KCLabeledValueView: KCStackView, KCValueViewInterface
{
	public var value: CNValue {
		get {
			var result: Dictionary<String, CNValue> = [:]
			for subview in self.arrangedSubviews() {
				if let labview = subview as? KCLabeledStackView {
					let labval = KCValueView.viewToValue(parent: labview.contentsView)
					result[labview.title] = labval
				} else {
					CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
				}
			}
			return .dictionaryValue(result)
		}
		set(newval){
			if let dict = newval.toDictionary() {
				self.removeAllArrangedSubviews()
				let keys = dict.keys.sorted()
				for key in keys {
					let labview = KCLabeledStackView()
					labview.title = key
					if let subval = dict[key] {
						KCValueView.valueToView(value: subval, parent: labview.contentsView)
					} else {
						CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
					}
					self.addArrangedSubView(subView: labview)
				}
			} else {
				CNLog(logLevel: .error, message: "Not dictionary value", atFunction: #function, inFile: #file)
			}
			requireUpdate(view: self)
		}
	}
}

open class KCValueView: KCStackView, KCValueViewInterface
{
	public var value: CNValue {
		get {
			return KCValueView.viewToValue(parent: self)
		}
		set(newval) {
			self.removeAllArrangedSubviews()
			KCValueView.valueToView(value: newval, parent: self)
			requireUpdate(view: self)
			self.notify(viewControlEvent: .updateSize)
		}
	}

	public static func valueToView(value val: CNValue, parent parview: KCStackView) {
		switch val {
		case .nullValue:
			break
		case .boolValue(_), .numberValue(_), .stringValue(_), .dateValue(_), .URLValue(_), .imageValue(_), .objectValue(_):
			let view = KCScalarValueView()
			view.value = val
			parview.addArrangedSubView(subView: view)
		case .rangeValue(_), .pointValue(_), .sizeValue(_), .rectValue(_), .enumValue(_, _), .colorValue(_):
			let view = KCDictionaryValueView()
			view.value = val
			parview.addArrangedSubView(subView: view)
		case .dictionaryValue(let dict):
			if dict.count > 0 {
				if KCValueView.hasScalarValues(dictionary: dict) {
					let view = KCDictionaryValueView()
					view.value = val
					parview.addArrangedSubView(subView: view)
				} else {
					let view = KCLabeledValueView()
					view.value = val
					parview.addArrangedSubView(subView: view)
				}
			}
		case .arrayValue(let arr):
			if arr.count > 0 {
				let view = KCArrayValueView()
				view.value = val
				parview.addArrangedSubView(subView: view)
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown value type", atFunction: #function, inFile: #file)
		}
	}

	public static func viewToValue(parent parview: KCStackView) -> CNValue {
		let subviews = parview.arrangedSubviews()
		let result: CNValue
		switch subviews.count {
		case 0:
			result = .nullValue
		case 1:
			if let subview = subviews[0] as? KCValueViewInterface {
				result = subview.value
			} else {
				CNLog(logLevel: .error, message: "Invalid subview (1)", atFunction: #function, inFile: #file)
				result = .nullValue
			}
		default:
			var values: Array<CNValue> = []
			for subview in subviews {
				if let valview = subview as? KCValueViewInterface {
					values.append(valview.value)
				} else {
					CNLog(logLevel: .error, message: "Invalid subview (2)", atFunction: #function, inFile: #file)
				}
			}
			result = .arrayValue(values)
		}
		return result
	}

	private static func hasScalarValues(dictionary dict: Dictionary<String, CNValue>) -> Bool {
		var result = true
		for (_, val) in dict {
			if !CNValueType.isScaler(type: val.valueType) {
				result = false
				break
			}
		}
		return result
	}
}


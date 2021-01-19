/**
 * @file	KCTableCellConverted.m
 * @brief	Define KCTableCellConvcerter class
 * @par Copyright
 *   Copyright (C) 2014-2016 Steel Wheels Project
 * @par Reference
 *   <a href="http://lowlife.jp/yasusii/static/color_chart.html">RGB Color Chart</a>
 */

import CoconutData
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public protocol KCTableCellConverting {
	func covertToView(value val: CNNativeValue) -> KCView?
}

public class KCTableCellCoverter: KCTableCellConverting {
	public func covertToView(value val: CNNativeValue) -> KCView? {
		let result: KCView?
		switch val {
		case .URLValue(let url):
			result = valueToView(string: url.path)
		case .imageValue(let img):
			result = valueToView(image: img)
		case .dateValue(let date):
			result = valueToView(string: date.description)
		case .enumValue(let str, let val):
			let lab = "\(str)(\(val))"
			result = valueToView(string: lab)
		case .nullValue:
			result = valueToView(string: "")
		case .numberValue(let num):
			result = valueToView(string: num.description(withLocale: nil))
		case .pointValue(let pt):
			result = valueToView(string: pt.description)
		case .rangeValue(let rng):
			result = valueToView(string: rng.description)
		case .sizeValue(let size):
			result = valueToView(string: size.description)
		case .stringValue(let str):
			result = valueToView(string: str)
		case .rectValue(let rect):
			result = valueToView(string: rect.description)
		case .anyObjectValue(_), .arrayValue(_), .colorValue(_), .dictionaryValue(_):
			result = nil
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown case at \(#function)")
			result = nil
		}
		return result
	}

	private func valueToView(string val: String) -> KCTextEdit {
		let textview  = KCTextEdit()
		textview.mode = .label
		textview.text = val
		return textview
	}

	private func valueToView(image val: CNImage) -> KCImageView {
		let imgview = KCImageView()
		imgview.set(image: val)
		return imgview
	}
}

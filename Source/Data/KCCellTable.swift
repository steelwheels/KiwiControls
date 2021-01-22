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

public protocol KCCellTableInterface
{
	func addColumn(title ttl: String) -> Bool
	func columnTitle(index idx: Int) -> String?
	func numberOfColumns() -> Int

	func numberOfRows(columnIndex colidx: Int) -> Int?
	func numberOfRows(columnName colname: String) -> Int?
	func maxNumberOfRows() -> Int

	func view(colmunName cname: String, rowIndex ridx: Int) -> KCView?
	func set(colmunName cname: String, rowIndex ridx: Int, data dat: Any?)
	func append(colmunName cname: String, data dat: Any?)
}

private class KCCellColumn {
	public var	title:		String
	public var	values:		Array<CNNativeValue>

	public init(title ttl: String){
		title	= ttl
		values	= []
	}
}

public class KCCellTable: KCCellTableInterface
{
	private var mTitles: 	Dictionary<String, Int>		// <Name, Index>
	private var mColumns:	Array<KCCellColumn>

	public init(){
		mTitles		= [:]
		mColumns	= []
	}

	public func addColumn(title ttl: String) -> Bool {
		if mTitles[ttl] == nil {
			let idx = mTitles.count
			mTitles[ttl] = idx
			let newcell = KCCellColumn(title: ttl)
			mColumns.append(newcell)
			return true
		} else {
			return false
		}
	}

	public func columnTitle(index idx: Int) -> String? {
		if 0<=idx && 0<mColumns.count {
			return mColumns[idx].title
		} else {
			return nil
		}
	}

	public func numberOfColumns() -> Int {
		return mColumns.count
	}

	public func numberOfRows(columnIndex idx: Int) -> Int? {
		if 0<=idx && idx<mColumns.count {
			return mColumns[idx].values.count
		} else {
			return nil
		}
	}

	public func numberOfRows(columnName name: String) -> Int? {
		if let idx = mTitles[name] {
			return mColumns[idx].values.count
		} else {
			return nil
		}
	}

	public func maxNumberOfRows() -> Int {
		var maxnum = 0
		for col in mColumns {
			maxnum = max(maxnum, col.values.count)
		}
		return maxnum
	}

	public func view(colmunName name: String, rowIndex ridx: Int) -> KCView? {
		if let cidx = mTitles[name] {
			let col = mColumns[cidx]
			if 0<=ridx && ridx<col.values.count {
				return covertToView(value: col.values[ridx])
			}
		}
		return nil
	}

	public func set(colmunName cname: String, rowIndex ridx: Int, data dat: Any?) {
		if let val = dat as? CNNativeValue {
			set(colmunName: cname, rowIndex: ridx, value: val)
		} else {
			NSLog("KCCellTable: set \(String(describing: dat))")
		}
	}

	public func set(colmunName cname: String, rowIndex ridx: Int, value val: CNNativeValue) {
		if let cidx = mTitles[cname] {
			let col  = mColumns[cidx]
			let cnum = col.values.count
			if 0<=ridx && ridx<cnum {
				col.values[ridx] = val
			} else if ridx == cnum {
				col.values.append(val)
			}
		} else {
			NSLog("KCCellTable: Failed to set: \(cname)")
		}
	}

	public func append(colmunName cname: String, data dat: Any?) {
		if let val = dat as? CNNativeValue {
			append(colmunName: cname, value: val)
		} else {
			NSLog("KCCellTable: append \(String(describing: dat))")
		}
	}

	public func append(colmunName cname: String, value val: CNNativeValue) {
		if let cidx = mTitles[cname] {
			let col = mColumns[cidx]
			col.values.append(val)
		} else {
			NSLog("KCCellTable: Failed to append: \(cname)")
		}
	}

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



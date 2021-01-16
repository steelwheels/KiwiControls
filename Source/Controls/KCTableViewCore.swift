/**
 * @file	KCTableViewCore.swift
 * @brief	Define KCTableViewCore class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

#if os(OSX)
	public typealias KCTableViewDelegate = NSTableViewDelegate
#else
	public typealias KCTableViewDelegate = UITableViewDelegate
#endif

open class KCTableViewCore : KCView, KCTableViewDelegate
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	private var mTableData:		CNTableData? = nil
	public var  visibleColmunNum:	Int = 0
	public var  visibleRowNum:	Int = 0

	public func setup(frame frm: CGRect) {
		KCView.setAutolayoutMode(views: [self, mTableView])
		mTableView.delegate = self
	}

	public func setDataTable(tableData tdata: CNTableData) {
		/* Set data source */
		mTableData = tdata
		let source = KCTableDataSource(tableData: tdata)
		mTableView.dataSource = source

		#if os(OSX)
		/* Remove current columns */
		for col in mTableView.tableColumns {
			mTableView.removeTableColumn(col)
		}
		/* Add new columns */
		for col in tdata.columns() {
			let newcol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: col.title))
			newcol.title      = col.title
			newcol.isEditable = col.isEditable
			mTableView.addTableColumn(newcol)
		}
		#endif
		self.invalidateIntrinsicContentSize()
	}

	#if os(OSX)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let col = tableColumn, let table = mTableData {
			if let cdata = table.column(name: col.title) {
				if let val = cdata.get(index: row) {
					return valueToView(value: val)
				}
			}
		}
		CNLog(logLevel: .error, message: "No matched view: \(String(describing: tableColumn?.title)) \(row) at \(#function)")
		return nil
	}
	#endif

	open func valueToView(value val: CNNativeValue) -> KCView? {
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

	public func valueToView(string val: String) -> KCTextEdit {
		let textview  = KCTextEdit()
		textview.mode = .label
		textview.text = val
		return textview
	}

	public func valueToView(image val: CNImage) -> KCImageView {
		let imgview = KCImageView()
		imgview.set(image: val)
		return imgview
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		#if os(OSX)
			mTableView.setFrameSize(newsize)
		#else
			mTableView.setFrameSize(size: newsize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			#if os(OSX)
			let spacing = mTableView.intercellSpacing

			var width: CGFloat = 0.0
			let colnum: Int
			if self.visibleColmunNum > 0 {
				colnum = self.visibleColmunNum
			} else {
				colnum = self.columnNum
			}
			for i in 0..<colnum {
				if let view = mTableView.view(atColumn: i, row: 0, makeIfNecessary: false) {
					let vsize = view.intrinsicContentSize
					width += vsize.width
				}
			}
			if colnum >= 1 {
				width += spacing.width * CGFloat(colnum)
			}

			var height: CGFloat = mTableView.intrinsicContentSize.height
			let rownum: Int
			if self.visibleRowNum > 0 {
				rownum = self.visibleRowNum
			} else {
				rownum = self.rowNum
			}
			for i in 0..<rownum {
				if let view = mTableView.view(atColumn: 0, row: i, makeIfNecessary: false) {
					let vsize = view.intrinsicContentSize
					height += vsize.height
				}
			}
			if rownum >= 1 {
				height += spacing.height * CGFloat(rownum)
			}

			let result = KCSize(width: width, height: height)
			return result
			#else
			return mTableView.intrinsicContentSize
			#endif
		}
	}

	public var rowNum: Int {
		get {
			if let table = mTableData {
				return table.numberOfRows
			} else {
				return 0
			}
		}
	}

	public var columnNum: Int {
		get {
			if let table = mTableData {
				return table.numberOfColmns
			} else {
				return 0
			}
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTableView.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mTableView.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
	}
}


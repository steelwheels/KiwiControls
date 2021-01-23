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
	public typealias KCTableViewDelegate    = NSTableViewDelegate
	public typealias KCTableViewDataSource  = NSTableViewDataSource
#else
	public typealias KCTableViewDelegate    = UITableViewDelegate
	public typealias KCTableViewDataSource  = UITableViewDataSource
#endif

open class KCTableViewCore : KCView, KCTableViewDelegate, KCTableViewDataSource
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	private var mCellTable:			KCCellTableInterface?
	public var  numberOfVisibleColmuns:	Int = 0
	public var  numberOfVisibleRows:	Int = 0
	public var  cellPressedCallback: ((_ column: String, _ row: Int) -> Void)? = nil

	public func setup(frame frm: CGRect) {
		KCView.setAutolayoutMode(views: [self, mTableView])
		mTableView.delegate   = self
		mTableView.dataSource = self

		#if os(OSX)
			mTableView.target = self
			mTableView.doubleAction = #selector(doubleClicked)
		#endif
	}

	public var cellTable: KCCellTableInterface? {
		get {
			return mCellTable
		}
		set(tbl) {
			mCellTable = tbl
			if let t = tbl {
				updateTable(cellTable: t)
			}
		}
	}

	private func updateTable(cellTable ctable: KCCellTableInterface) {
		#if os(OSX)
		/* Remove current columns */
		while mTableView.tableColumns.count > 0 {
			let col = mTableView.tableColumns[0]
			mTableView.removeTableColumn(col)
		}
		/* Add columns */
		let colnum = ctable.numberOfColumns()
		for i in 0..<colnum {
			if let colname = ctable.columnTitle(index: i) {
				let newcol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: colname))
				newcol.title      = colname
				newcol.isEditable = false
				mTableView.addTableColumn(newcol)
			}
		}
		/* Request reload */
		mTableView.reloadData()
		self.invalidateIntrinsicContentSize()
		#endif
	}

	#if os(OSX)
	@objc func doubleClicked(sender: AnyObject) {
		let rowidx = mTableView.clickedRow
		let colidx = mTableView.clickedColumn
		if let cbfunc = self.cellPressedCallback, let ctable = mCellTable {
			let colnum = ctable.numberOfColumns()
			if let rownum = ctable.numberOfRows(columnIndex: colidx) {
				if colidx < colnum && rowidx < rownum {
					let col = mTableView.tableColumns[colidx]
					cbfunc(col.title, rowidx)
				}
			}
		} else {
			print("double clicked col:\(colidx) row:\(rowidx)")
		}
	}
	#endif

	/*
	 * Delegate
	 */
	#if os(OSX)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let col = tableColumn, let ctable = mCellTable {
			return ctable.view(colmunName: col.title, rowIndex: row)
		}
		CNLog(logLevel: .error, message: "No matched view: \(String(describing: tableColumn?.title)) \(row) at \(#function)")
		return nil
	}
	#endif

	/*
	 * DataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		if let ctable = mCellTable {
			return ctable.maxNumberOfRows()
		} else {
			return 0
		}
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		if let col = tableColumn, let ctable = mCellTable {
			return ctable.view(colmunName: col.title, rowIndex: row)
		} else {
			CNLog(logLevel: .error, message: "No valid column")
			return nil
		}
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let ctable = mCellTable  {
			ctable.set(colmunName: col.title, rowIndex: row, data: object)
		} else {
			CNLog(logLevel: .error, message: "No valid column")
		}
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let ctable = mCellTable {
			return ctable.maxNumberOfRows()
		} else {
			return 0
		}
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		return cell
	}
	#endif

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
			if self.numberOfVisibleColmuns > 0 {
				colnum = self.numberOfVisibleColmuns
			} else {
				colnum = self.numberOfColumns
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
			if self.numberOfVisibleRows > 0 {
				rownum = self.numberOfVisibleRows
			} else {
				rownum = self.numberOfRows
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

	public var numberOfRows: Int {
		get {
			#if os(OSX)
				return mTableView.numberOfRows
			#else
				return mTableView.numberOfRows(inSection: 0)
			#endif
		}
	}

	public var numberOfColumns: Int {
		get {
			#if os(OSX)
				return mTableView.numberOfColumns
			#else
				return 1
			#endif
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


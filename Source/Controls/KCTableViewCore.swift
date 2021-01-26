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
	public var  cellPressedCallback: ((_ col: Int, _ row: Int) -> Void)? = nil

	public func setup(frame frm: CGRect) {
		KCView.setAutolayoutMode(views: [self, mTableView])
		mTableView.delegate   = self
		mTableView.dataSource = self

		#if os(OSX)
			mTableView.target			= self
			mTableView.doubleAction 		= #selector(doubleClicked)
			mTableView.allowsColumnReordering	= false
			mTableView.allowsColumnResizing		= false
			mTableView.allowsColumnSelection	= true
			mTableView.allowsMultipleSelection	= false
			mTableView.allowsEmptySelection		= true
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
					cbfunc(colidx, rowidx)
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

			let viscolnum: Int
			if self.numberOfVisibleColmuns > 0 {
				viscolnum = self.numberOfVisibleColmuns
			} else if let ctable = mCellTable {
				viscolnum = ctable.numberOfColumns()
			} else {
				viscolnum = 1
			}

			let visrownum: Int
			if self.numberOfVisibleRows > 0 {
				visrownum = self.numberOfVisibleRows
			} else if let ctable = mCellTable {
				visrownum = ctable.maxNumberOfRows()
			} else {
				visrownum = 1
			}

			let result: KCSize
			if let view = mTableView.view(atColumn: 0, row: 0, makeIfNecessary: false) {
				let inset: CGFloat = 10.0
				let vsize  = view.intrinsicContentSize
				let width  = vsize.width * CGFloat(viscolnum)
					   + spacing.width  * CGFloat(viscolnum + 1) + (inset*2.0)
				let height = vsize.height * CGFloat(visrownum)
					   + spacing.height * CGFloat(visrownum + 1) + (inset*2.0)
				result = KCSize(width: width, height: height)
			} else {
				result = KCSize(width: -1.0, height: 14)
			}
			//NSLog("intrinsicContentsSize: \(viscolnum)x\(visrownum) -> \(result.description)")
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

	public func view(atColumn col: Int, row rw: Int) -> KCView? {
		#if os(OSX)
			return mTableView.view(atColumn: col, row: rw, makeIfNecessary: false) as? KCView
		#else
			return nil
		#endif
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


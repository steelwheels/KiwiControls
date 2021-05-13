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

		/* Give column names if it is not defined yet */
		let colnum = ctable.columnCount
		for i in 0..<colnum {
			if ctable.title(column: i) == nil {
				ctable.setTitle(column: i, title: "__\(i)")
			}
		}

		/* Add columns */
		for i in 0..<colnum {
			if let colname = ctable.title(column: i) {
				let newcol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: colname))
				newcol.title      = colname
				newcol.isEditable = false
				mTableView.addTableColumn(newcol)
			}
		}

		self.reload()
		#endif
	}

	public func reload() {
		/* Request reload */
		#if os(OSX)
		mTableView.noteNumberOfRowsChanged()
		#endif
		mTableView.reloadData()
		self.invalidateIntrinsicContentSize()
		//NSLog("invalidate intrinsic contents size at \(#function)")
	}

	#if os(OSX)
	@objc func doubleClicked(sender: AnyObject) {
		let rowidx = mTableView.clickedRow
		let colidx = mTableView.clickedColumn
		if let cbfunc = self.cellPressedCallback, let ctable = mCellTable {
			let colnum = ctable.columnCount
			let rownum = ctable.rowCount
			if colidx < colnum && rowidx < rownum {
				cbfunc(colidx, rowidx)
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
			return ctable.rowCount
		} else {
			NSLog("No cell table (0) at \(#function)")
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
			return ctable.rowCount
		} else {
			NSLog("No cell table (1) at \(#function)")
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

	open override var intrinsicContentSize: KCSize { get {
		#if os(OSX)
		let spacing = mTableView.intercellSpacing

		let viscolnum: Int
		let visrownum: Int
		if let ctable = mCellTable {
			viscolnum = ctable.columnCount
			visrownum = ctable.rowCount
		} else {
			viscolnum = 1
			visrownum = 1
		}

		var result = KCSize.zero
		NSLog("iCS (b)")
		for x in 0..<viscolnum {
			var maxwidth:    CGFloat = 0.0
			var totalheight: CGFloat = 0.0
			NSLog("iCS (0) x=\(x)")
			for y in 0..<visrownum {
				NSLog("iCS (1): y=\(y)")
				if let view = mTableView.view(atColumn: x, row: y, makeIfNecessary: false) {
					let vsize = view.intrinsicContentSize
					NSLog("iCS (2): vsize=\(vsize.description)")
					maxwidth    =  max(maxwidth, vsize.width + spacing.width)
					totalheight += vsize.height + spacing.height
				}

			}
			result.width  += maxwidth
			result.height =  max(result.height, totalheight)
			NSLog("iCS (3): result=\(result.description)")
		}
		NSLog("iCS (e): result=\(result.description)")
		result.width  += spacing.width
		result.height += spacing.height

		NSLog("intrinsicContentsSize: \(viscolnum)x\(visrownum) -> \(result.description) at \(#function)")
		return result
		#else
		return mTableView.intrinsicContentSize
		#endif
	}}

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
			let view = mTableView.view(atColumn: col, row: rw, makeIfNecessary: false) as? KCView
			NSLog("view: \(view)")
			return view
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


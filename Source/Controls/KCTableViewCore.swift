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

private class KCViewTable
{
	private var mTable: 		Array<Array<KCView?>>
	private var mRowCount:		Int
	private var mColumnCount:	Int

	public var description: String { get {
		var fillnum:  Int = 0
		var emptynum: Int = 0
		for row in mTable {
			for elm in row {
				if elm != nil {
					fillnum += 1
				} else {
					emptynum += 1
				}
			}
		}
		return "{filled:\(fillnum), empty:\(emptynum)}"
	}}

	public init(columnCount ccnt: Int, rowCount rcnt: Int){
		mTable       = Array(repeating: Array(repeating: nil, count: ccnt), count: rcnt)
		mRowCount    = rcnt
		mColumnCount = ccnt
	}

	public func get(column cidx: Int, row ridx: Int) -> KCView? {
		if 0<=cidx && cidx<mColumnCount && 0<=ridx && ridx<mRowCount {
			return mTable[ridx][cidx]
		} else {
			return nil
		}
	}

	public func set(column cidx: Int, row ridx: Int, view v: KCView) {
		if 0<=cidx && cidx<mColumnCount && 0<=ridx && ridx<mRowCount {
			mTable[ridx][cidx] = v
		} else {
			CNLog(logLevel: .error, message: "Failed to set: cidx=\(cidx), ridx=\(ridx)", atFunction: #function, inFile: #file)
		}
	}

	public func isFilled() -> Bool {
		var filled = true
		for row in mTable {
			for elm in row {
				if elm == nil {
					filled = false
					break
				}
			}
		}
		return filled
	}
}


open class KCTableViewCore : KCView, KCTableViewDelegate, KCTableViewDataSource
{
	public typealias ViewAllocator = (_ value: CNNativeValue) -> KCView?

	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	private var	mValueTable:		CNNativeValueTable
	private var 	mIsReloading:		Bool
	private var 	mViewTable:		KCViewTable
	private var	mViewAllocator:		ViewAllocator?

	public var 	cellPressedCallback: 	((_ col: Int, _ row: Int) -> Void)? = nil

	#if os(OSX)
	public override init(frame : NSRect){
		mValueTable	= CNNativeValueTable()
		mIsReloading	= false
		mViewTable	= KCViewTable(columnCount: 1, rowCount: 1)
		mViewAllocator	= nil
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mValueTable	= CNNativeValueTable()
		mIsReloading	= false
		mViewTable	= KCViewTable(columnCount: 1, rowCount: 1)
		mViewAllocator	= nil
		super.init(frame: frame)
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 346)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		mValueTable	= CNNativeValueTable()
		mIsReloading	= false
		mViewTable	= KCViewTable(columnCount: 1, rowCount: 1)
		mViewAllocator	= nil
		super.init(coder: coder)
	}

	public var valueTable: CNNativeValueTable {
		get      { return mValueTable	}
	}

	public func setup(frame frm: CGRect, viewAllocator valloc: @escaping ViewAllocator) {
		mViewAllocator = valloc

		KCView.setAutolayoutMode(views: [self, mTableView])
		mTableView.delegate   = self
		mTableView.dataSource = self

		mValueTable.setValue(column: 0, row: 0, value: .nullValue)

		#if os(OSX)
			mTableView.target			= self
			mTableView.doubleAction 		= #selector(doubleClicked)
			mTableView.allowsColumnReordering	= false
			mTableView.allowsColumnResizing		= false
			mTableView.allowsColumnSelection	= false
			mTableView.allowsMultipleSelection	= false
			mTableView.allowsEmptySelection		= true
			mTableView.usesAutomaticRowHeights	= true
			//mTableView.columnAutoresizingStyle	= .noColumnAutoresizing
		#endif
	}

	public func reloadTable() {
		#if os(OSX)

		mTableView.beginUpdates()

		/* Remove current columns */
		while mTableView.tableColumns.count > 0 {
			let col = mTableView.tableColumns[0]
			mTableView.removeTableColumn(col)
		}

		/* Add columns */
		let colnum = mValueTable.columnCount
		for i in 0..<colnum {
			let colname = mValueTable.title(column: i)
			let newcol  = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: colname))
			newcol.title      = colname
			newcol.isEditable = false
			mTableView.addTableColumn(newcol)
		}

		mTableView.endUpdates()

		/* Allocate view table */
		mViewTable = KCViewTable(columnCount: colnum, rowCount: mValueTable.rowCount)

		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()
		mIsReloading = true

		#endif
	}

	private func allocateView(title ttl: String, row ridx: Int) -> KCView {
		if let view = viewInTable(columnTitle: ttl, rowIndex: ridx) {
			return view
		}
		let val = mValueTable.value(title: ttl, row: ridx)
		if let valloc = mViewAllocator {
			if let view = valloc(val) {
				setViewToTable(columnTitle: ttl, rowIndex: ridx, view: view)
				return view
			}
		}
		let newview = valueToView(value: val)
		setViewToTable(columnTitle: ttl, rowIndex: ridx, view: newview)
		return newview
	}

	private func allocateView(column cidx: Int, row ridx: Int) -> KCView {
		if let view = viewInTable(columnIndex: cidx, rowIndex: ridx) {
			return view
		}
		let val = mValueTable.value(column: cidx, row: ridx)
		if let valloc = mViewAllocator {
			if let view = valloc(val) {
				setViewToTable(columnIndex: cidx, rowIndex: ridx, view: view)
				return view
			}
		}
		let newview = valueToView(value: val)
		setViewToTable(columnIndex: cidx, rowIndex: ridx, view: newview)
		return newview
	}

	private func viewInTable(columnIndex cidx: Int, rowIndex ridx: Int) -> KCView? {
		return mViewTable.get(column: cidx, row: ridx)
	}

	private func viewInTable(columnTitle title: String, rowIndex ridx: Int) -> KCView? {
		if let cidx = mValueTable.titleIndex(by: title) {
			return mViewTable.get(column: cidx, row: ridx)
		} else {
			return nil
		}
	}

	private func setViewToTable(columnIndex cidx: Int, rowIndex ridx: Int, view newview: KCView){
		mViewTable.set(column: cidx, row: ridx, view: newview)
	}

	private func setViewToTable(columnTitle title: String, rowIndex ridx: Int, view newview: KCView){
		if let cidx = mValueTable.titleIndex(by: title) {
			mViewTable.set(column: cidx, row: ridx, view: newview)
		} else {
			CNLog(logLevel: .error, message: "Failed to set new view", atFunction: #function, inFile: #file)
		}
	}

	private func valueToView(value val: CNNativeValue) -> KCView {
		let result: KCView
		switch val {
		case .stringValue(let str):
			result = textToView(text: str)
		case .imageValue(let img):
			let view = KCImageView()
			view.set(image: img)
			result = view
		default:
			let str = val.toText().toStrings(terminal: "").joined(separator: "\n")
			result = textToView(text: str)
		}
		#if os(OSX)
		let size = result.fittingSize
		result.setFrameSize(size)
		#endif
		return result
	}

	private func textToView(text txt: String) -> KCView {
		let textview  = KCTextEdit()
		textview.text = txt
		textview.isBezeled = false
		return textview
	}

	#if os(OSX)
	private func calcContentSize() -> KCSize {
		let space = mTableView.intercellSpacing
		var result: KCSize = KCSize.zero
		for cidx in 0..<mTableView.numberOfColumns {
			var width:  CGFloat = 0.0
			var height: CGFloat = 0.0
			for ridx in 0..<mTableView.numberOfRows {
				let view  = allocateView(column: cidx, row: ridx)
				let fsize = view.intrinsicContentSize
				width     = max(width, fsize.width + space.width)
				height    += fsize.height + space.height
			}
			result.width  += width
			result.height =  max(result.height, height)
		}
		return result
	}
	#endif

	#if os(OSX)
	@objc func doubleClicked(sender: AnyObject) {
		let rowidx = mTableView.clickedRow
		let colidx = mTableView.clickedColumn
		if let cbfunc = self.cellPressedCallback {
			let colnum = mValueTable.columnCount
			let rownum = mValueTable.rowCount
			if colidx < colnum && rowidx < rownum {
				cbfunc(colidx, rowidx)
			}
		} else {
			print("double clicked col:\(colidx) row:\(rowidx)")
		}
	}
	#endif

	public var hasGrid: Bool {
		get {
			#if os(OSX)
				if mTableView.gridStyleMask.contains(.solidHorizontalGridLineMask) {
					return true
				} else {
					return false
				}
			#else
				if mTableView.separatorStyle == .none {
					return false
				} else {
					return true
				}
			#endif
		}
		set(doenable){
			#if os(OSX)
				if doenable {
					let pref = CNPreference.shared.viewPreference
					mTableView.gridStyleMask.insert(.solidHorizontalGridLineMask)
					mTableView.gridStyleMask.insert(.solidVerticalGridLineMask)
					mTableView.gridColor = pref.foregroundColor
				} else {
					mTableView.gridStyleMask.remove(.solidHorizontalGridLineMask)
					mTableView.gridStyleMask.remove(.solidVerticalGridLineMask)
				}
			#else
				if doenable {
					mTableView.separatorStyle = .singleLine
				} else {
					mTableView.separatorStyle = .none
				}
			#endif

		}
	}

	/*
	 * Delegate
	 */
	#if os(OSX)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row ridx: Int) -> NSView? {
		if let col = tableColumn {
			let result = allocateView(title: col.title, row: ridx)
			if mIsReloading && mViewTable.isFilled() {
				self.invalidateIntrinsicContentSize()
				self.notify(viewControlEvent: .updateSize)
				mIsReloading = false
			}
			return result
		}
		CNLog(logLevel: .error, message: "No matched view: \(String(describing: tableColumn?.title)) \(ridx) at \(#function)")
		return nil
	}
	#endif

	/*
	 * DataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return mValueTable.rowCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		if let col = tableColumn {
			return mValueTable.value(title: col.title, row: row)
		} else {
			CNLog(logLevel: .error, message: "No valid column")
			return nil
		}
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let val = object as? CNNativeValue {
			mValueTable.setValue(title: col.title, row: row, value: val)
		} else {
			CNLog(logLevel: .error, message: "No valid column")
		}
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mValueTable.rowCount
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
		if mViewTable.isFilled() {
			return calcContentSize()
		} else {
			return mTableView.intrinsicContentSize
		}
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

	public func view(atColumn cidx: Int, row ridx: Int) -> KCView? {
		return allocateView(column: cidx, row: ridx)
	}

	#if os(OSX)
	public func tableView(_ tableView: NSTableView, heightOfRow ridx: Int) -> CGFloat {
		let view = allocateView(column: 0, row: ridx)
		let size = view.intrinsicContentSize
		return size.height
	}

	public func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn cidx: Int) -> CGFloat {
		let view = allocateView(column: cidx, row: 0)
		let size = view.intrinsicContentSize
		return size.width
	}
	#endif

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		mTableView.invalidateIntrinsicContentSize()
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		mTableView.setExpansionPriorities(priorities: prival)
		super.setExpandabilities(priorities: prival)
	}
}


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
			CNLog(logLevel: .error, message: "Failed to set: cidx=\(cidx), ridx=\(ridx) columnCount=\(mColumnCount) rowCount=\(mRowCount)", atFunction: #function, inFile: #file)
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


open class KCTableViewCore : KCCoreView, KCTableViewDelegate, KCTableViewDataSource
{
	public typealias ViewAllocator = (_ value: CNNativeValue, _ iseditable: Bool) -> KCView?

	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	private var	mTableInterface:	CNNativeTableInterface
	private var	mIsEditable:		Bool
	private var 	mIsReloading:		Bool
	private var 	mViewTable:		KCViewTable
	private var	mPreviousTable:		KCViewTable?
	private var	mViewAllocator:		ViewAllocator?

	public var 	cellPressedCallback: 	((_ col: Int, _ row: Int) -> Void)? = nil

	#if os(OSX)
	public override init(frame : NSRect){
		mTableInterface	= CNNativeValueTable()
		mIsEditable	= false
		mIsReloading	= false
		mViewTable	= KCViewTable(columnCount: 1, rowCount: 1)
		mPreviousTable	= nil
		mViewAllocator	= nil
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mTableInterface	= CNNativeValueTable()
		mIsEditable	= false
		mIsReloading	= false
		mViewTable	= KCViewTable(columnCount: 1, rowCount: 1)
		mPreviousTable	= nil
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
		mTableInterface	= CNNativeValueTable()
		mIsEditable	= false
		mIsReloading	= false
		mViewTable	= KCViewTable(columnCount: 1, rowCount: 1)
		mPreviousTable	= nil
		mViewAllocator	= nil
		super.init(coder: coder)
	}

	public var isEditable: Bool {
		get	 { return mIsEditable	}
		set(val) { mIsEditable = val 	}
	}

	public func setup(frame frm: CGRect, viewAllocator valloc: @escaping ViewAllocator) {
		super.setup(isSingleView: true, coreView: mTableView)
		mViewAllocator = valloc

		KCView.setAutolayoutMode(views: [self, mTableView])
		mTableView.delegate   = self
		mTableView.dataSource = self

		/* Add dummy cell */
		mTableInterface.setValue(columnIndex: .number(0), row: 0, value: .nullValue)

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

		reloadTable(table: nil)
	}

	public func reloadTable(table tbl: CNNativeTableInterface?) {
		#if os(OSX)
		if let newtbl = tbl {
			mTableInterface = newtbl
		}

		/* Allocate view table. This must be allocate before modifying views
		 */
		mPreviousTable = mViewTable
		mViewTable     = KCViewTable(columnCount: mTableInterface.columnCount, rowCount: mTableInterface.rowCount)

		mTableView.beginUpdates()

		/* Remove current columns */
		while mTableView.tableColumns.count > 0 {
			let col = mTableView.tableColumns[0]
			mTableView.removeTableColumn(col)
		}

		/* Add columns */
		for i in 0..<mTableInterface.columnCount {
			let colname       = mTableInterface.title(column: i)
			let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: colname))
			newcol.title      = colname
			newcol.isEditable = false
			mTableView.addTableColumn(newcol)
		}

		if mTableInterface.hasHeader {
			mTableView.headerView = NSTableHeaderView()
		} else {
			mTableView.headerView = nil
		}

		mTableView.endUpdates()

		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()
		mIsReloading = true

		#endif
	}

	private func allocateView(columnIndex cidx: CNColumnIndex, row ridx: Int) -> KCView {
		if let view = viewInTable(columnIndex: cidx, rowIndex: ridx) {
			return view
		}
		let val = mTableInterface.value(columnIndex: cidx, row: ridx)
		if let valloc = mViewAllocator {
			if let view = valloc(val, mIsEditable) {
				setViewToTable(columnIndex: cidx, rowIndex: ridx, view: view)
				return view
			}
		}
		let newview = valueToView(value: val, isEditable: mIsEditable, atColumnIndex: cidx, row: ridx)
		setViewToTable(columnIndex: cidx, rowIndex: ridx, view: newview)
		return newview
	}

	private func viewInTable(columnIndex cidx: CNColumnIndex, rowIndex ridx: Int) -> KCView? {
		switch cidx {
		case .number(let num):
			return mViewTable.get(column: num, row: ridx)
		case .title(let str):
			if let num = mTableInterface.titleIndex(by: str) {
				return mViewTable.get(column: num, row: ridx)
			} else {
				return nil
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			return nil
		}
	}

	private func setViewToTable(columnIndex cidx: CNColumnIndex, rowIndex ridx: Int, view newview: KCView){
		switch cidx {
		case .number(let num):
			mViewTable.set(column: num, row: ridx, view: newview)
		case .title(let str):
			if let num = mTableInterface.titleIndex(by: str) {
				mViewTable.set(column: num, row: ridx, view: newview)
			} else {
				CNLog(logLevel: .error, message: "Failed to set new view: title=\(str)", atFunction: #function, inFile: #file)
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
		}
	}

	private func valueToView(value val: CNNativeValue, isEditable edt: Bool, atColumnIndex cidx: CNColumnIndex, row ridx: Int) -> KCView {
		let result: KCView
		switch val {
		case .stringValue(let str):
			let view = textToView(text: str, atColumnIndex: cidx, row: ridx, isEditable: edt)
			result = view
		case .imageValue(let img):
			let view = KCImageView()
			view.set(image: img)
			result = view
		default:
			let str = val.toText().toStrings().joined(separator: "\n")
			result = textToView(text: str, atColumnIndex: cidx, row: ridx, isEditable: edt)
		}
		#if os(OSX)
		let size = result.fittingSize
		result.setFrameSize(size)
		#endif
		return result
	}

	private func textToView(text txt: String, atColumnIndex cidx: CNColumnIndex, row ridx: Int, isEditable edt: Bool) -> KCTextEdit {
		let textview  = KCTextEdit()
		textview.text       = txt
		textview.isEditable = edt
		textview.isBezeled  = false
		textview.callbackFunction = {
			(_ value: CNNativeValue) -> Void in
			self.didEndEditing(value: value, atColumnIndex: cidx, row: ridx)
		}
		return textview
	}

	public var firstResponderView: KCView? { get {
		if mIsEditable {
			#if os(OSX)
			let cidx = max(mTableView.selectedColumn, 0)
			let ridx = max(mTableView.selectedRow, 0)
			#else
			let cidx = 0
			let ridx = 0
			#endif
			return mViewTable.get(column: cidx, row: ridx)
		} else {
			return nil
		}
	}}

	#if os(OSX)
	private func calcContentSize() -> KCSize {
		let space = mTableView.intercellSpacing
		var result: KCSize = KCSize.zero
		for cidx in 0..<mTableView.numberOfColumns {
			var width:  CGFloat = 0.0
			var height: CGFloat = 0.0
			for ridx in 0..<mTableView.numberOfRows {
				let view  = allocateView(columnIndex: .number(cidx), row: ridx)
				let fsize = view.intrinsicContentSize
				width     = max(width, fsize.width + space.width)
				height    += fsize.height + space.height
			}
			result.width  += width
			result.height =  max(result.height, height)
		}
		if let header = mTableView.headerView {
			var height: CGFloat = 0.0
			for cidx in 0..<numberOfColumns {
				let colsize = header.headerRect(ofColumn: cidx)
				height = max(height, colsize.height)
			}
			result.height += height
		}
		return result
	}

	@IBAction func mCellAction(_ sender: Any) {
		if mIsEditable {
			let cidx = mTableView.clickedColumn
			let ridx = mTableView.clickedRow
			if let view = mViewTable.get(column: cidx, row: ridx) {
				notify(viewControlEvent: .switchFirstResponder(view))
			}
		}
	}

	@objc func doubleClicked(sender: AnyObject) {
		let rowidx = mTableView.clickedRow
		let colidx = mTableView.clickedColumn
		if let cbfunc = self.cellPressedCallback {
			let colnum = mTableInterface.columnCount
			let rownum = mTableInterface.rowCount
			if colidx < colnum && rowidx < rownum {
				cbfunc(colidx, rowidx)
			}
		} else {
			print("double clicked col:\(colidx) row:\(rowidx)")
		}
	}

	public override var acceptsFirstResponder: Bool {
		get { return mIsEditable }
	}

	public override func becomeFirstResponder() -> Bool {
		return mTableView.becomeFirstResponder()
	}
	#endif

	open func didEndEditing(value val: CNNativeValue, atColumnIndex cidx: CNColumnIndex, row ridx: Int) {
		mTableInterface.setValue(columnIndex: cidx, row: ridx, value: val)
	}
	
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
			let result = allocateView(columnIndex: .title(col.title), row: ridx)
			requestLayoutIfAllViewsHadBeenAllocated()
			return result
		}
		CNLog(logLevel: .error, message: "No matched view: \(String(describing: tableColumn?.title)) \(ridx) at \(#function)")
		return nil
	}

	public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return false
	}

	public func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
		return false
	}
	#endif

	/*
	 * DataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return mTableInterface.rowCount
	}
	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mTableInterface.rowCount
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		return cell
	}
	#endif

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
		let newview = allocateView(columnIndex: .number(cidx), row: ridx)
		requestLayoutIfAllViewsHadBeenAllocated()
		return newview
	}

	private func requestLayoutIfAllViewsHadBeenAllocated() {
		if mIsReloading && mViewTable.isFilled() {
			/* Link responder chain */
			/* Request reload*/
			self.invalidateIntrinsicContentSize()
			self.notify(viewControlEvent: .updateSize)
			mIsReloading = false
		}
	}

	#if os(OSX)
	public func tableView(_ tableView: NSTableView, heightOfRow ridx: Int) -> CGFloat {
		let view = allocateView(columnIndex: .number(0), row: ridx)
		let size = view.intrinsicContentSize
		return size.height
	}

	public func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn cidx: Int) -> CGFloat {
		let view = allocateView(columnIndex: .number(cidx), row: 0)
		let size = view.intrinsicContentSize
		return size.width
	}
	#endif

	#if os(OSX)
	open override var fittingSize: KCSize {
		get { return contentSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return contentSize()
	}
	#endif

	open override var intrinsicContentSize: KCSize {
		get { return contentSize() }
	}

	private func contentSize() -> KCSize {
		#if os(OSX)
		if mViewTable.isFilled() {
			return calcContentSize()
		} else {
			return mTableView.intrinsicContentSize
		}
		#else
		return mTableView.intrinsicContentSize
		#endif
	}
}


/**
 * @file	KCTableViewCore.swift
 * @brief	Define KCTableViewCore class
 * @par Copyright
 *   Copyright (C) 2017-2021 Steel Wheels Project
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

open class KCTableViewCore : KCCoreView, KCTableViewDelegate, KCTableViewDataSource, KCTableCellDelegate
{
	public typealias ClickCallbackFunction       = (_ double: Bool, _ record: CNRecord, _ field: String) -> Void
	public typealias DidSelectedCallbackFunction = (_ selected: Bool) -> Void
	public typealias FilterFunction	     	     = CNMappingTable.FilterFunction

	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	public struct FieldName {
		public var field:	String
		public var title:	String

		public init(field fld: String, title ttl: String){
			field	= fld
			title	= ttl
		}
	}

	private var mDataTable:			CNMappingTable
	private var mFieldNames:		Array<FieldName>
	private var mMinimumVisibleRowCount:	Int

	private var mNextDataTable:		CNMappingTable?
	private var mNextFieldNames:		Array<FieldName>?
	private var mNextRecordMappingFunction:	FilterFunction?
	private var mNextVirtualFields:		Dictionary<String, CNMappingTable.VirtualFieldCallback>?

	private var mHasHeader:			Bool
	private var mIsEnable:			Bool
	private var mIsEditable:		Bool

	private var mCellClickedCallback:	ClickCallbackFunction?       = nil
	private var mDidSelectedCallback:	DidSelectedCallbackFunction? = nil

	#if os(OSX)
	public override init(frame : NSRect){
		let (table, fields) = KCTableViewCore.allocateDummyTable()
		mDataTable		= table
		mFieldNames		= fields
		mNextDataTable		= nil
		mNextFieldNames		= nil
		mNextVirtualFields	= nil
		mMinimumVisibleRowCount	= 8
		mHasHeader		= false
		mIsEnable		= false
		mIsEditable		= false
		super.init(frame: frame)
	}
	#else
	public override init(frame : CGRect){
		let (table, fields) = KCTableViewCore.allocateDummyTable()
		mDataTable		= table
		mFieldNames		= fields
		mNextDataTable		= nil
		mNextFieldNames		= nil
		mNextVirtualFields	= nil
		mMinimumVisibleRowCount	= 8
		mHasHeader		= false
		mIsEnable		= false
		mIsEditable		= false
		super.init(frame: frame)
	}
	#endif

	public required init?(coder: NSCoder) {
		let (table, fields) = KCTableViewCore.allocateDummyTable()
		mDataTable		= table
		mFieldNames		= fields
		mNextDataTable		= nil
		mNextFieldNames		= nil
		mNextVirtualFields	= nil
		mMinimumVisibleRowCount	= 8
		mHasHeader		= false
		mIsEnable		= false
		mIsEditable		= false
		super.init(coder: coder)
	}

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 346)
		#endif
		self.init(frame: frame)
	}

	public static func allocateDummyTable() -> (CNMappingTable, Array<FieldName>) {
		guard let srcfile   = CNFilePath.URLForResourceDirectory(directoryName: "Data", subdirectory: nil, forClass: KCTableViewCore.self) else {
			fatalError("Can not allocate resource URL")
		}
		//let cachefile = CNFilePath.URLforApplicationSupportDirectory(subDirectory: "Data")
		let storage   = CNStorage(sourceDirectory: srcfile, cacheDirectory: srcfile, filePath: "dummy-table.json")
		switch storage.load() {
		case .success(_):
			break
		case .failure(let err):
			CNLog(logLevel: .error, message: err.toString(), atFunction: #function, inFile: #file)
		}
		let path      = CNValuePath(identifier: nil, elements: [.member("table")])
		let table     = CNStorageTable(path: path, storage: storage)
		let fields    = KCTableViewCore.allocateFieldNames(from: table)
		return (CNMappingTable(sourceTable: table), fields)
	}

	private static func allocateFieldNames(from table: CNTable) -> Array<FieldName> {
		var result: Array<FieldName> = []
		for (key, _) in table.defaultFields {
			result.append(FieldName(field: key, title: key))
		}
		return result
	}

	public var numberOfRows: Int 	{ get {
		#if os(OSX)
			return mTableView.numberOfRows
		#else
			return 0
		#endif
	}}

	public var numberOfColumns: Int { get {
		#if os(OSX)
			return mTableView.numberOfColumns
		#else
			return 0
		#endif
	}}

	public func setup(frame frm: CGRect) {
		super.setup(isSingleView: true, coreView: mTableView)

		KCView.setAutolayoutMode(views: [self, mTableView])
		mTableView.delegate   = self
		mTableView.dataSource = self

		#if os(OSX)
			mTableView.target			= self
			mTableView.doubleAction 		= #selector(doubleClicked)
			mTableView.columnAutoresizingStyle	= .sequentialColumnAutoresizingStyle
			mTableView.allowsColumnReordering	= false
			mTableView.allowsColumnResizing		= false
			mTableView.allowsColumnSelection	= false
			mTableView.allowsMultipleSelection	= false
			mTableView.allowsEmptySelection		= true
			mTableView.usesAutomaticRowHeights	= true
			mTableView.usesAlternatingRowBackgroundColors	= false
			//mTableView.columnAutoresizingStyle	= .noColumnAutoresizing
		#endif

		reload(table: mDataTable, fieldNames: mFieldNames)
	}

	public var dataTable: CNTable {
		get         {
			return mNextDataTable ?? mDataTable
		}
		set(newval) {
			if let mtable = newval as? CNMappingTable {
				mNextDataTable = mtable
			} else {
				mNextDataTable = CNMappingTable(sourceTable: newval)
			}
		}
	}

	public var filterFunction: FilterFunction? {
		get         { return mNextRecordMappingFunction   }
		set(newval) { mNextRecordMappingFunction = newval }
	}

	public var fieldNames: Array<FieldName> {
		get         { return mNextFieldNames ?? [] }
		set(newval) { mNextFieldNames = newval     }
	}

	public func fieldName(at idx: Int) -> FieldName? {
		let names = self.fieldNames
		if 0<=idx && idx<names.count {
			return names[idx]
		} else {
			return nil
		}
	}

	public func addVirtualField(name field: String, callbackFunction cbfunc: @escaping CNMappingTable.VirtualFieldCallback) {
		if mNextVirtualFields != nil {
			mNextVirtualFields![field] = cbfunc
		} else {
			let fields: Dictionary<String, CNMappingTable.VirtualFieldCallback> = [field: cbfunc]
			mNextVirtualFields = fields
		}
	}

	public var hasHeader: Bool {
		get	    { return mHasHeader}
		set(newval) { mHasHeader = newval }
	}

	public var hasGrid: Bool {
		get {
			#if os(OSX)
				return mTableView.gridStyleMask.contains(.solidHorizontalGridLineMask)
			#else
				return mTableView.separatorStyle != .none
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

	public var isEnable: Bool {
		get         { return mIsEnable }
		set(newval) { mIsEnable = newval }
	}

	public var isEditable: Bool {
		get         { return mIsEditable   }
		set(newval) { mIsEditable = newval }
	}

	public var minimumVisibleRowCount: Int {
		get      { return mMinimumVisibleRowCount	}
		set(cnt) { mMinimumVisibleRowCount = cnt	}
	}

	public var cellClickedCallback: ClickCallbackFunction? {
		get         { return mCellClickedCallback   }
		set(newval) { mCellClickedCallback = newval }
	}

	public var didSelectedCallback: DidSelectedCallbackFunction? {
		get         { return mDidSelectedCallback   }
		set(newval) { mDidSelectedCallback = newval }
	}

	public func reload() {
		if let tbl = mNextDataTable, let fld = mNextFieldNames {
			reload(table: tbl, fieldNames: fld)
		} else {
			CNLog(logLevel: .error, message: "No parameter for reload", atFunction: #function, inFile: #file)
		}
	}

	private func reload(table tbl: CNTable, fieldNames fnames: Array<FieldName>){
		#if os(OSX)
		mTableView.beginUpdates()

		/* set header */
		if let _ = mTableView.headerView {
			if !mHasHeader {
				/* ON -> OFF */
				mTableView.headerView = nil
			}
		} else {
			if mHasHeader {
				/* OFF -> ON */
				mTableView.headerView = NSTableHeaderView()
			}
		}

		/* Remove all current columns */
		while mTableView.tableColumns.count > 0 {
			if let col = mTableView.tableColumns.last {
				mTableView.removeTableColumn(col)
			}
		}
		/* Add all new columns */
		let newcolnum = fnames.count
		for i in 0..<newcolnum {
			let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: fnames[i].field))
			newcol.title      = fnames[i].title
			newcol.isHidden	  = false
			newcol.isEditable = mIsEditable
			newcol.minWidth	  = 64
			newcol.maxWidth	  = 1000
			mTableView.addTableColumn(newcol)
		}
		mTableView.endUpdates()

		/* Set field names */
		mFieldNames	= fnames

		/* Allocate new table */
		mDataTable = CNMappingTable(sourceTable: tbl)
		if let filter = mNextRecordMappingFunction {
			mDataTable.setFilter(filterFunction: filter)
			//mNextRecordMappingFunction = nil
		}
		if let fields = mNextVirtualFields {
			mDataTable.mergeVirtualFields(callbacks: fields)
			mNextVirtualFields = nil
		}

		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()
		#endif
	}

	@IBAction func mCellAction(_ sender: Any) {
		click(isDouble: false)
	}

	@objc func doubleClicked(sender: AnyObject) {
		click(isDouble: true)
	}

	private func click(isDouble double: Bool) {
		#if os(OSX)
			let rowidx = mTableView.clickedRow
			let colidx = mTableView.clickedColumn

			/* Callback: clicked */
			if 0<=rowidx && rowidx < mDataTable.recordCount, let colname = fieldName(at: colidx) {
				if let rec = mDataTable.record(at: rowidx), let cbfunc = self.mCellClickedCallback {
					cbfunc(double, rec, colname.field)
				} else {
					CNLog(logLevel: .detail, message: "Clicked col:\(colname) row:\(rowidx)", atFunction: #function, inFile: #file)
				}
			}
			/* Callback: didSelected */
			if let cbfunc = mDidSelectedCallback {
				cbfunc(true) // callback
			}
		#endif
	}

	public func selectedRecords() -> Array<CNRecord> {
		#if os(OSX)
			let sets = mTableView.selectedRowIndexes
			var result: Array<CNRecord> = []
			sets.forEach({
				(_ idx: Int) -> Void in
				if let rec = mDataTable.record(at: idx) {
					result.append(rec)
				} else {
					CNLog(logLevel: .error, message: "No record at index:\(idx)", atFunction: #function, inFile: #file)
				}
			})
			return result
		#else
			return []
		#endif
	}

	public func removeSelectedRows() {
		#if os(OSX)
		let sets = mTableView.selectedRowIndexes
		if !sets.isEmpty {
			/* Remove data from table */
			sets.forEach({
				(_ idx: Int) -> Void in
				if !mDataTable.remove(at: idx) {
					CNLog(logLevel: .error, message: "Failed to remove row data: \(idx)", atFunction: #function, inFile: #file)
				}
			})

			/* Remove from table view */
			mTableView.beginUpdates()
			mTableView.removeRows(at: sets, withAnimation: .slideUp)
			mTableView.endUpdates()

			/* Callback: didSelected */
			if let cbfunc = didSelectedCallback {
				cbfunc(false) // callback
			}
		}
		#endif
	}

	#if os(OSX)
	public func tableCellView(shouldEndEditing view: KCTableCellView, columnTitle title: String, rowIndex ridx: Int, value val: CNValue) {
		if let rec = mDataTable.record(at: ridx) {
			if rec.setValue(value: val, forField: title) {
				return
			}
		}
		CNLog(logLevel: .error, message: "Failed to set value", atFunction: #function, inFile: #file)
	}
	#endif

	/*
	 * dataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return mDataTable.recordCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		var result: CNValue = .nullValue
		if let col = tableColumn {
			if let rec = mDataTable.record(at: row) {
				if let val = rec.value(ofField: col.identifier.rawValue){
					result = val
				}
			}
		}
		return result
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let val = object as? CNValue {
			if let rec = mDataTable.record(at: row) {
				if rec.setValue(value: val, forField: col.identifier.rawValue) {
					return
				}
			}
		}
		CNLog(logLevel: .error, message: "Failed to set object value", atFunction: #function, inFile: #file)
	}
	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
	#endif

	/*
	 * Delegate
	 */
	#if os(OSX)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let newview = mTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tableCellView"), owner: mTableView)
		if let cell = newview as? KCTableCellView {
			let title: String
			if let col = tableColumn {
				title = col.title
			} else {
				title = ""
			}
			cell.setup(title: title, row: row, delegate: self)
			cell.isEnabled  = mIsEnable
			cell.isEditable = mIsEditable
		} else {
			CNLog(logLevel: .error, message: "Unexpected cell view", atFunction: #function, inFile: #file)
		}
		return newview
	}
	#endif

	/*
	 * Layout
	 */
	public func view(atColumn cidx: Int, row ridx: Int) -> KCViewBase? {
		#if os(OSX)
		if let view = mTableView.view(atColumn: cidx, row: ridx, makeIfNecessary: false) {
			return view
		} else {
			return nil
		}
		#else
		return nil
		#endif
	}

	public override func setFrameSize(_ newsize: CGSize) {
		super.setFrameSize(newsize)
	}

	public override var intrinsicContentSize: CGSize {
		#if os(OSX)
		let size: CGSize = calcContentSize()
		#else
		let size = super.intrinsicContentSize
		#endif
		return size
	}

	#if os(OSX)
	private func calcContentSize() -> CGSize {
		var result = CGSize.zero
		let space  = mTableView.intercellSpacing
		if let header = mTableView.headerView {
			result        =  header.frame.size
			result.height += space.height
		}
		let actnum = min(mTableView.numberOfRows, mMinimumVisibleRowCount)
		if actnum > 0 {
			var frame: CGRect = CGRect.zero
			/* Calc for non-empty rows */
			for ridx in 0..<actnum {
				if let rview = mTableView.rowView(atRow: ridx, makeIfNecessary: true) {
					frame = rview.frame
					result.width  =  max(result.width, frame.size.width)
					result.height += frame.size.height
				}
			}
			/* Calc for non-empty rows */
			for _ in actnum..<mMinimumVisibleRowCount {
				result.width  =  max(result.width, frame.size.width)
				result.height += frame.size.height
			}
			/* Calc for space */
			if mMinimumVisibleRowCount > 1 {
				result.height += space.height * CGFloat(mMinimumVisibleRowCount - 1)
			}
			return result
		} else {
			/* Calc dummy size. The unit size is given from XIB setting */
			let unitsize = CGSize(width: 124, height: 17)
			var result   = CGSize(width: unitsize.width * CGFloat(mFieldNames.count), height: unitsize.height * CGFloat(mMinimumVisibleRowCount))
			/* Calc for space */
			if mMinimumVisibleRowCount > 1 {
				result.height += space.height * CGFloat(mMinimumVisibleRowCount - 1)
			}
			return result
		}
	}
	#endif

	public var firstResponderView: KCViewBase? { get {
		#if os(OSX)
		let row = mTableView.clickedRow
		let col = mTableView.clickedColumn
		if 0<=row && row<mTableView.numberOfRows && 0<=col && col<mTableView.numberOfColumns {
			if let cell = mTableView.view(atColumn: col, row: row, makeIfNecessary: false) as? KCTableCellView {
				return cell.firstResponderView
			}
		}
		#endif
		return nil
	}}
}

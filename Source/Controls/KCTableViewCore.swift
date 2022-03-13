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

public class KCDataTable
{
	private var mRecords:		Array<KCDataRecord>

	public var recordCount: Int { get { return mRecords.count }}

	public init(){
		mRecords	= []
	}

	public static func allocateDummyTable() -> KCDataTable {
		let newtable = KCDataTable()
		let rec0 = KCDataRecord()
		rec0.set(value: .stringValue(" "), forKey: "c0")
		newtable.append(record: rec0)
		return newtable
	}

	public func load(table tbl: CNTable) {
		var newrecords: Array<KCDataRecord> = []
		let count = tbl.recordCount
		for i in 0..<count {
			if let rec = tbl.record(at: i) {
				let newrec = KCDataRecord.allocate(record: rec)
				newrecords.append(newrec)
			}
		}
		mRecords = newrecords
	}

	public func record(at index: Int) -> KCDataRecord? {
		if 0<=index && index<mRecords.count {
			return mRecords[index]
		} else {
			return nil
		}
	}

	public func append(record rec: KCDataRecord){
		mRecords.append(rec)
	}

	public func remove(at index: Int) -> Bool {
		if 0<=index && index<mRecords.count {
			mRecords.remove(at: index)
			return true
		} else {
			return false
		}
	}

	public func sort(byDescriptors desc: CNSortDescriptors){
		CNLog(logLevel: .error, message: "Not supported", atFunction: #function, inFile: #file)
	}
}

public class KCDataRecord
{
	private var mValues:		Dictionary<String, CNValue>

	public var keys: Array<String> { get {
		return Array(mValues.keys)
	}}

	public init(){
		mValues		= [:]
	}

	public static func allocate(record rec: CNRecord) -> KCDataRecord {
		let newrec = KCDataRecord()
		let names  = rec.fieldNames
		for name in names {
			if let val = rec.value(ofField: name) {
				newrec.set(value: val, forKey: name)
			} else {
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		}
		return newrec
	}

	public func set(value val: CNValue, forKey key: String){
		mValues[key] = val
	}

	public func value(forKey key: String) -> CNValue? {
		return mValues[key]
	}
}

public class KCTableField
{
	public struct FieldName {
		var field:	String
		var title:	String

		public init(field fld: String, title ttl: String){
			field	= fld
			title	= ttl
		}
	}

	private var mFieldNameCache:		Array<FieldName>?
	private var mUserDefinedFieldNames:	Array<FieldName>?

	public var userDefinedFieldNames: Array<FieldName>? {
		get	    { return mUserDefinedFieldNames	}
		set(newval) { mUserDefinedFieldNames = newval ; mFieldNameCache = nil }
	}

	public init(){
		mFieldNameCache		= nil
		mUserDefinedFieldNames	= nil
	}

	public func fieldNames(fromTable tbl: KCDataTable) -> Array<FieldName> {
		if let cache = mFieldNameCache {
			return cache
		} else if let users = mUserDefinedFieldNames {
			mFieldNameCache = users
			return users
		} else {
			/* Collect field names from table */
			var names: Array<String> = []
			let cnt = tbl.recordCount
			for i in 0..<cnt {
				if let rec = tbl.record(at: i) {
					for key in rec.keys {
						if !names.contains(key) {
							names.append(key)
						}
					}
				}
			}
			let fields = names.map{ return FieldName(field: $0, title: $0) }
			mUserDefinedFieldNames = fields
			return fields
		}
	}

	public func fieldName(fromTable tbl: KCDataTable, at index: Int) -> FieldName? {
		let names = fieldNames(fromTable: tbl)
		if 0<=index && index<names.count {
			return names[index]
		} else {
			return nil
		}
	}
}

open class KCTableViewCore : KCCoreView, KCTableViewDelegate, KCTableViewDataSource, KCTableCellDelegate
{
	public typealias FieldName = KCTableField.FieldName

	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	public var cellClickedCallback: ((_ double: Bool, _ colname: String, _ rowidx: Int) -> Void)? = nil
	public var didSelectedCallback: ((_ selected: Bool) -> Void)? = nil
	public var hasHeader:		Bool = false
	public var isEnable:		Bool = true
	public var isSelectable:	Bool = false

	private var mMinimumVisibleRowCount:	Int

	private var mDataTable:			KCDataTable
	private var mTableField:		KCTableField
	private var mReloadedCount:		Int
	private var mReloadStack:		CNStack<CNTable>
	private var mSortDescriptors:		CNSortDescriptors

	#if os(OSX)
	public override init(frame : NSRect){
		mMinimumVisibleRowCount	= 8
		mTableField		= KCTableField()
		mDataTable		= KCDataTable.allocateDummyTable()
		mReloadedCount 		= 0
		mReloadStack		= CNStack<CNTable>()
		mSortDescriptors	= CNSortDescriptors()
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mMinimumVisibleRowCount	= 8
		mTableField		= KCTableField()
		mDataTable		= KCDataTable.allocateDummyTable()
		mReloadedCount  	= 0
		mReloadStack		= CNStack<CNTable>()
		mSortDescriptors	= CNSortDescriptors()
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
		mMinimumVisibleRowCount	= 8
		mTableField		= KCTableField()
		mDataTable		= KCDataTable.allocateDummyTable()
		mReloadedCount 		= 0
		mReloadStack		= CNStack<CNTable>()
		mSortDescriptors	= CNSortDescriptors()
		super.init(coder: coder)
	}

	public var numberOfRows: Int 	{ get {
		return mDataTable.recordCount
	}}

	public var numberOfColumns: Int { get {
		return mTableField.fieldNames(fromTable: mDataTable).count
	}}

	public var minimumVisibleRowCount: Int {
		get      { return mMinimumVisibleRowCount	}
		set(cnt) { mMinimumVisibleRowCount = cnt	}
	}

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

		reloadTable()
	}

	public var fieldNames: Array<FieldName>? {
		get        { return mTableField.userDefinedFieldNames }
		set(names) { mTableField.userDefinedFieldNames = names }
	}

	public func reload(table tbl: CNTable) {
		if mReloadedCount > 0 {
			/* Push as the target */
			mReloadStack.push(tbl)
		} else {
			/* Reload now */
			reloadNow(table: tbl)
		}
	}

	private func reloadDone() -> Bool {
		if let tbl = mReloadStack.pop() {
			reloadNow(table: tbl)
			return false 	// continue to reload
		} else {
			return true	// needless to reload
		}
	}

	private func reloadNow(table tbl: CNTable) {
		mDataTable.load(table: tbl)
		reloadTable()
	}

	private func reloadTable() {
		#if os(OSX)
		CNLog(logLevel: .detail, message: "Reload table contents", atFunction: #function, inFile: #file)

		let fnames  = mTableField.fieldNames(fromTable: mDataTable)
		let fcounts = fnames.count

		let rcounts    = mDataTable.recordCount
		mReloadedCount = rcounts * fcounts

		mTableView.beginUpdates()

		/* Adjust column numbers */
		if fcounts < mTableView.tableColumns.count {
			/* Remove some columns */
			let delnum = mTableView.tableColumns.count - fcounts
			for _ in 0..<delnum {
				let col = mTableView.tableColumns[0]
				mTableView.removeTableColumn(col)

			}
		} else if fcounts > mTableView.tableColumns.count {
			/* Append empty columns */
			for _ in mTableView.tableColumns.count..<fcounts {
				let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "?"))
				newcol.title      = "?"
				newcol.isHidden	  = false
				mTableView.addTableColumn(newcol)
			}
		}

		/* Update column titles */
		for i in 0..<fcounts {
			let col 	= mTableView.tableColumns[i]
			col.identifier	= NSUserInterfaceItemIdentifier(fnames[i].field)
			col.title	= fnames[i].title
			col.isHidden	= false
			col.minWidth	= 64
			col.maxWidth	= 1000
		}

		if hasHeader {
			mTableView.headerView = NSTableHeaderView()
		} else {
			mTableView.headerView = nil
		}

		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()

		mTableView.endUpdates()
		self.requireDisplay()
		#endif
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

	#if os(OSX)
	@IBAction func mCellAction(_ sender: Any) {
		click(isDouble: false)
	}

	@objc func doubleClicked(sender: AnyObject) {
		click(isDouble: true)
	}

	private func click(isDouble double: Bool) {
		let rowidx = mTableView.clickedRow
		let colidx = mTableView.clickedColumn
		if 0<=rowidx && rowidx < mDataTable.recordCount, let colname = mTableField.fieldName(fromTable: mDataTable, at: colidx) {
			/* Select row */
			let idxs = IndexSet(integer: rowidx)
			mTableView.selectRowIndexes(idxs, byExtendingSelection: false)
			/* Callback: clicked */
			if let cbfunc = self.cellClickedCallback {
				cbfunc(double, colname.field, rowidx)
			} else {
				CNLog(logLevel: .detail, message: "Clicked col:\(colname) row:\(rowidx)", atFunction: #function, inFile: #file)
			}
			/* Callback: didSelected */
			if let cbfunc = didSelectedCallback {
				cbfunc(true) // callback
			}
			/* Update first responder */
			if let view = mTableView.view(atColumn: colidx, row: rowidx, makeIfNecessary: false) as? KCTableCellView {
				if let resp = view.firstResponderView {
					CNLog(logLevel: .detail, message: "click -> notify", atFunction: #function, inFile: #file)
					notify(viewControlEvent: .switchFirstResponder(resp))
				}
			}
		} else {
			/* Callback: didSelected */
			if let cbfunc = didSelectedCallback {
				cbfunc(false) // callback
			}
		}
	}
	#endif // os(OSX)

	public func removeSelectedRows() {
		#if os(OSX)
		let sets = mTableView.selectedRowIndexes
		if !sets.isEmpty {
			/* Remove data from table */
			sets.forEach({
				(_ idx: Int) -> Void in
				if !mDataTable.remove(at: idx) {
					CNLog(logLevel: .error, message: "Failed to remove row data", atFunction: #function, inFile: #file)
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

	/*
	 * KCTableViewDataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return mDataTable.recordCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		var result: CNValue = .nullValue
		if let col = tableColumn {
			if let rec = mDataTable.record(at: row) {
				if let val = rec.value(forKey: col.identifier.rawValue) {
					result = val
				}
			}
		}
		if mReloadedCount > 0 && hasValidColumn(viewFor: tableColumn){
			mReloadedCount -= 1
			if mReloadedCount == 0 {
				CNLog(logLevel: .detail, message: "Reloaded ... Notify resize", atFunction: #function, inFile: #file)
				if self.reloadDone() {
					self.invalidateIntrinsicContentSize()
					self.requireLayout()
					notify(viewControlEvent: .updateSize(self))
				}
			}
		}
		return result
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let val = object as? CNValue {
			if let rec = mDataTable.record(at: row) {
				rec.set(value: val, forKey: col.identifier.rawValue)
				return
			}
		}
		CNLog(logLevel: .error, message: "Failed to set object value", atFunction: #function, inFile: #file)
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mDataTable.recordCount
	}

	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableCellView", for: indexPath)
		return cell
	}
	#endif

	/*
	 * KCTableViewDelegate
	 */
	#if os(OSX)
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row ridx: Int) -> NSView? {
		let newview = mTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tableCellView"), owner: mTableView)
		if let cell = newview as? KCTableCellView {
			let title: String
			if let col = tableColumn {
				title = col.title
			} else {
				title = ""
			}
			cell.setup(title: title, row: ridx, delegate: self)
			cell.isEnabled  = self.isEnable
		} else {
			CNLog(logLevel: .error, message: "Unexpected cell view", atFunction: #function, inFile: #file)
		}
		return newview
	}

	private func hasValidColumn(viewFor tableColumn: NSTableColumn?) -> Bool {
		let result: Bool
		if let col = tableColumn {
			result = (col.title != "?")
		} else {
			result = false
		}
		return result
	}

	public func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
		let doascend: Bool
		if let val = mSortDescriptors.ascending(for: tableColumn.title) {
			doascend = !val
		} else {
			doascend = false
		}
		mSortDescriptors.add(key: tableColumn.title, ascending: doascend)

		mDataTable.sort(byDescriptors: mSortDescriptors)
		mTableView.reloadData()
	}
	#endif

	/*
	 * KCTableCellDelegate
	 */
	#if os(OSX)
	public func tableCellView(shouldEndEditing view: KCTableCellView, columnTitle title: String, rowIndex ridx: Int, value val: CNValue) {
		if let rec = mDataTable.record(at: ridx) {
			rec.set(value: val, forKey: title)
		} else {
			CNLog(logLevel: .error, message: "Failed to set value", atFunction: #function, inFile: #file)
		}
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
		let size: CGSize
		if let sz = calcContentSize() {
			size = sz
		} else {
			CNLog(logLevel: .error, message: "Failed to calc content size", atFunction: #function, inFile: #file)
			size = super.intrinsicContentSize
		}
		#else
		let size = super.intrinsicContentSize
		#endif
		return size
	}

	#if os(OSX)
	private func calcContentSize() -> CGSize? {
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
			return nil
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

	/*
	 * Debug
	 */
	public func dump(){
		#if os(OSX)
		for cidx in 0..<numberOfColumns {
			for ridx in 0..<numberOfRows {
				if let cell = mTableView.view(atColumn: cidx, row: ridx, makeIfNecessary: false) {
					NSLog(" frame: \(cell.frame.description)")
				}
			}
		}
		#endif
	}
}

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

private protocol KCTableInterface
{
	var rowCount: 		Int		{ get }
	var columnCount:	Int		{ get }
	var fieldNames:		Array<String> 	{ get }

	func fieldName(atIndex idx: Int) -> String?

	func value(row ridx: Int, column col: String) -> CNValue
	func setValue(value val: CNValue, row ridx: Int, column col: String) -> Bool
	func sortRows(by desc: CNSortDescriptors)
}

private class KCTableBridge: KCTableInterface
{
	private var mTable: 		CNTable
	private var mFieldNames:	Array<String>

	public init(table tbl: CNTable){
		mTable 		= tbl
		mFieldNames	= []
	}

	public var rowCount:    Int     { get { return mTable.recordCount	}}
	public var columnCount: Int     { get { return mTable.fieldNames.count	}}
	public var core:	CNTable { get { return mTable			}}

	public var fieldNames: Array<String> { get { return mTable.fieldNames }}

	public func fieldName(atIndex idx: Int) -> String? {
		let names = mTable.fieldNames
		if 0<=idx && idx<names.count {
			return names[idx]
		} else {
			return nil
		}
	}

	public func value(row ridx: Int, column col: String) -> CNValue {
		if let rec = mTable.record(at: ridx) {
			if let val = rec.value(ofField: col) {
				return val
			}
		}
		return .nullValue
	}

	public func setValue(value val: CNValue, row ridx: Int, column col: String) -> Bool {
		if let rec = mTable.record(at: ridx) {
			return rec.setValue(value: val, forField: col)
		} else {
			return false
		}
	}

	public func sortRows(by desc: CNSortDescriptors) {
		mTable.sort(byDescriptors: desc)
	}
}


private class KCDictionaryTableBridge: KCTableInterface
{
	private static let KeyItem	= "key"
	private static let ValueItem	= "value"

	private var mDictionary: 	Dictionary<String, CNValue>
	private var mFieldNames:	Array<String>
	private var mRowToKey:		Dictionary<Int, String>
	private var mKeyToRow:		Dictionary<String, Int>

	public init(dictionary dict: Dictionary<String, CNValue>){
		mDictionary 	= dict
		mFieldNames	= [KCDictionaryTableBridge.KeyItem, KCDictionaryTableBridge.ValueItem]
		mRowToKey	= [:]
		mKeyToRow	= [:]

		updateCache()
	}

	private func updateCache(){
		mRowToKey = [:] ; mKeyToRow = [:]
		let keys = mDictionary.keys.sorted()
		for i in 0..<keys.count {
			mRowToKey[i]       = keys[i]
			mKeyToRow[keys[i]] = i
		}
	}

	public var rowCount: Int			{ get { return mDictionary.count	}}
	public var columnCount: Int			{ get { return mFieldNames.count	}}
	public var fieldNames: Array<String>		{ get { return mFieldNames		}}
	public var core: Dictionary<String, CNValue>	{ get { return mDictionary		}}

	public func fieldName(atIndex idx: Int) -> String? {
		if 0<=idx && idx<mFieldNames.count {
			return mFieldNames[idx]
		} else {
			return nil
		}
	}

	public func value(row ridx: Int, column col: String) -> CNValue {
		var result: CNValue = .nullValue
		switch col {
		case KCDictionaryTableBridge.KeyItem:
			if let key = mRowToKey[ridx] {
				result = .stringValue(key)
			}
		case KCDictionaryTableBridge.ValueItem:
			if let key = mRowToKey[ridx] {
				if let val = mDictionary[key] {
					result = val
				}
			}
		default:
			CNLog(logLevel: .error, message: "Unknown label: \(col)", atFunction: #function, inFile: #file)
		}
		return result
	}

	public func setValue(value val: CNValue, row ridx: Int, column col: String) -> Bool {
		var result = false
		switch col {
		case KCDictionaryTableBridge.KeyItem:
			CNLog(logLevel: .error, message: "Can not overwrite: \(col)", atFunction: #function, inFile: #file)
		case KCDictionaryTableBridge.ValueItem:
			if let key = mRowToKey[ridx] {
				mDictionary[key] = val
				result = true
			}
		default:
			CNLog(logLevel: .error, message: "Unknown label: \(col)", atFunction: #function, inFile: #file)
		}
		return result
	}

	public func sortRows(by desc: CNSortDescriptors) {
		/* Already sorted */
	}
}

open class KCTableViewCore : KCCoreView, KCTableViewDelegate, KCTableViewDataSource, KCTableCellDelegate
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	public enum DataState {
		case clean
		case dirty
	}

	public typealias StateListner = (_ state: DataState) -> Void

 	public var cellClickedCallback: ((_ double: Bool, _ colname: String, _ rowidx: Int) -> Void)? = nil
	public var hasHeader:		Bool = false
	public var isEnable:		Bool = true
	public var allowsRowSelection:	Bool = false

	public var visibleRowCount:	Int  = 20

	private var mDataState:		DataState
	private var mIsEditable:	Bool
	private var mStateListner:	StateListner?
	private var mTableInterface:	KCTableInterface
	private var mSortDescriptors:	CNSortDescriptors
	private var mReloadedCount:	Int

	#if os(OSX)
	public override init(frame : NSRect){
		mDataState		= .clean
		mIsEditable		= false
		mStateListner		= nil
		mTableInterface		= KCTableViewCore.allocateEmptyBridge()
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount 		= 0
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mDataState		= .clean
		mIsEditable		= false
		mStateListner		= nil
		mTableInterface		= KCTableViewCore.allocateEmptyBridge()
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount  	= 0
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
		mDataState		= .clean
		mIsEditable		= false
		mStateListner		= nil
		mTableInterface		= KCTableViewCore.allocateEmptyBridge()
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount 		= 0
		super.init(coder: coder)
	}

	static private func allocateEmptyBridge() -> KCTableBridge {
		let rec = CNValueRecord()
		let _   = rec.setValue(value: .nullValue, forField: "c0")
		let _   = rec.setValue(value: .nullValue, forField: "c1")
		let table = CNValueTable()
		table.append(record: rec)
		return KCTableBridge(table: table)
	}

	/*
	 * Action
	 */
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

		if 0<=rowidx && rowidx < mTableInterface.rowCount {
			if let colname = mTableInterface.fieldName(atIndex: colidx) {
				if let cbfunc = self.cellClickedCallback {
					cbfunc(double, colname, rowidx)
				} else {
					CNLog(logLevel: .detail, message: "Clicked col:\(colname) row:\(rowidx)", atFunction: #function, inFile: #file)
				}
				if let view = mTableView.view(atColumn: colidx, row: rowidx, makeIfNecessary: false) as? KCTableCellView {
					if let resp = view.firstResponderView {
						CNLog(logLevel: .detail, message: "click -> notify", atFunction: #function, inFile: #file)
						notify(viewControlEvent: .switchFirstResponder(resp))
					}
				}
			}
		}
	}
	#endif // os(OSX)

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

		store(table: nil)
	}

	/*
	 * Table
	 */
	public var isEditable:  Bool 	{ get { return mIsEditable	  		}}
	public var numberOfRows: Int 	{ get { return mTableInterface.rowCount		}}
	public var numberOfColumns: Int { get { return mTableInterface.columnCount	}}

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

	public func store(table tblp: CNTable?){
		let newif: KCTableInterface?
		if let tbl = tblp {
			newif = KCTableBridge(table: tbl)
		} else {
			newif = nil
		}
		store(interface: newif)
	}

	public func store(dictionary dictp: Dictionary<String, CNValue>?){
		let newif: KCTableInterface?
		if let dict = dictp {
			newif = KCDictionaryTableBridge(dictionary: dict)
		} else {
			newif = nil
		}
		store(interface: newif)
	}

	private func store(interface tbl: KCTableInterface?) {
		#if os(OSX)
		CNLog(logLevel: .detail, message: "Reload table contents", atFunction: #function, inFile: #file)
		if let newtbl = tbl {
			if newtbl.rowCount > 0 {
				mTableInterface = newtbl
			} else {
				mTableInterface = KCTableViewCore.allocateEmptyBridge()
			}
		}

		mTableView.beginUpdates()

		/* Adjust column numbers */
		if mTableInterface.columnCount < mTableView.tableColumns.count {
			/* Remove some columns */
			let delnum = mTableView.tableColumns.count - mTableInterface.columnCount
			for _ in 0..<delnum {
				let col = mTableView.tableColumns[0]
				mTableView.removeTableColumn(col)

			}
		} else if mTableInterface.columnCount > mTableView.tableColumns.count {
			let addnum = mTableInterface.columnCount - mTableView.tableColumns.count
			for _ in 0..<addnum {
				let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "?"))
				newcol.title      = "?"
				newcol.isHidden	  = false
				newcol.isEditable = mIsEditable
				mTableView.addTableColumn(newcol)
			}
		}

		/* Update column titles */
		let fnames = mTableInterface.fieldNames
		for i in 0..<mTableInterface.columnCount {
			let col = mTableView.tableColumns[i]
			col.identifier	= NSUserInterfaceItemIdentifier(fnames[i])
			col.title	= fnames[i]
			col.isHidden	= false
			col.minWidth	= 64
			col.maxWidth	= 1000
			col.isEditable	= mIsEditable
		}

		if hasHeader {
			mTableView.headerView = NSTableHeaderView()
		} else {
			mTableView.headerView = nil
		}

		mReloadedCount = mTableInterface.rowCount * mTableInterface.columnCount

		update(dataState: .clean)
		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()

		mTableView.endUpdates()

		#endif
	}

	public func loadTable() -> CNTable? {
		if let bridge = mTableInterface as? KCTableBridge {
			return bridge.core
		} else {
			return nil
		}
	}

	public func loadDictionary() -> Dictionary<String, CNValue>? {
		if let bridge = mTableInterface as? KCDictionaryTableBridge {
			return bridge.core
		} else {
			return nil
		}
	}

	/*
	 * KCTableViewDataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return mTableInterface.rowCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		if let col = tableColumn {
			return mTableInterface.value(row: row, column: col.title)
		} else {
			return CNValue.nullValue
		}
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let val = object as? CNValue {
			let _ = mTableInterface.setValue(value: val, row: row, column: col.title)
		} else {
			CNLog(logLevel: .error, message: "Failed to set object value", atFunction: #function, inFile: #file)
		}
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mTableInterface.rowCount
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
			cell.isEditable = mIsEditable
		} else {
			CNLog(logLevel: .error, message: "Unexpected cell view", atFunction: #function, inFile: #file)
		}
		if mReloadedCount > 0 {
			mReloadedCount -= 1
			if mReloadedCount == 0 {
				CNLog(logLevel: .detail, message: "Reloaded ... Notify resize", atFunction: #function, inFile: #file)
				self.invalidateIntrinsicContentSize()
				self.requireLayout()
				notify(viewControlEvent: .updateSize(self))
			}
		}
		return newview
	}

	public func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
		let doascend: Bool
		if let val = mSortDescriptors.ascending(for: tableColumn.title) {
			doascend = !val
		} else {
			doascend = false
		}
		mSortDescriptors.add(key: tableColumn.title, ascending: doascend)

		mTableInterface.sortRows(by: mSortDescriptors)
		mTableView.reloadData()
	}

	public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return self.allowsRowSelection
	}
	#endif

	/*
	 * KCTableCellDelegate
	 */
	#if os(OSX)
	public func tableCellView(shouldEndEditing view: KCTableCellView, columnTitle title: String, rowIndex ridx: Int, value val: CNValue) {
		let _ = mTableInterface.setValue(value: val, row: ridx, column: title)
		update(dataState: .dirty)
	}
	#endif

	/* Listner */
	public var stateListner: StateListner? {
		get		{ return mStateListner }
		set(listner)	{ mStateListner = listner }
	}

	private func update(dataState dst: DataState) {
		if let listner = mStateListner {
			if dst != mDataState {
				listner(dst)
				mDataState = dst
			}
		}
	}

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

	public override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
	}

	public override var intrinsicContentSize: KCSize {
		#if os(OSX)
		let size: KCSize
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
	private func calcContentSize() -> KCSize? {
		var result = KCSize.zero
		let space  = mTableView.intercellSpacing
		if let header = mTableView.headerView {
			result        =  header.frame.size
			result.height += space.height
		}
		let rownum = min(mTableView.numberOfRows, visibleRowCount)
		NSLog("calcContentSize: row num: \(rownum)")
		if rownum > 0 {
			for ridx in 0..<rownum {
				if let rview = mTableView.rowView(atRow: ridx, makeIfNecessary: true) {
					let frame = rview.frame
					NSLog("calcContentSize: frame(\(ridx)): \(frame.size.description)")
					result.width  =  max(result.width, frame.size.width)
					result.height += frame.size.height
				}
			}
			if rownum > 1 {
				result.height += space.height * CGFloat(rownum - 1)
			}
			NSLog("calcContentSize: calc content size: \(result.description)")
			NSLog("calcContentSize: fitting size:      \(mTableView.fittingSize.description)")
			return result
		} else {
			NSLog("calcContentSize: No result")
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


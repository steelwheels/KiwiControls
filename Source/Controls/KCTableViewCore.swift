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
	public struct ActiveFieldName {
		var field:	String
		var title:	String

		public init(field fld: String, title ttl: String){
			field	= fld
			title	= ttl
		}
	}

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
	public var didSelectedCallback: ((_ selected: Bool) -> Void)? = nil
	public var hasHeader:		Bool = false
	public var isEnable:		Bool = true
	public var isSelectable:	Bool = false

	private var mVisibleRowCount:	Int

	private var mDataTable:			CNTable
	private var mDataState:			DataState
	private var mDataListnerId:		Int?
	private var mActiveFieldNames:		Array<ActiveFieldName>
	private var mStateListner:		StateListner?
	private var mSortDescriptors:		CNSortDescriptors
	private var mReloadedCount:		Int

	#if os(OSX)
	public override init(frame : NSRect){
		mVisibleRowCount	= 8
		mDataState		= .clean
		mActiveFieldNames	= []
		mStateListner		= nil
		mDataTable		= KCTableViewCore.allocateEmptyTable()
		mDataListnerId		= nil
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount 		= 0
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mVisibleRowCount	= 8
		mDataState		= .clean
		mDataTable 		= KCTableViewCore.allocateEmptyTable()
		mDataListnerId		= nil
		mActiveFieldNames	= []
		mStateListner		= nil
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
		mVisibleRowCount	= 8
		mDataState		= .clean
		mDataTable 		= KCTableViewCore.allocateEmptyTable()
		mDataListnerId		= nil
		mActiveFieldNames	= []
		mStateListner		= nil
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount 		= 0
		super.init(coder: coder)
	}

	deinit {
		if let lid = mDataListnerId {
			mDataTable.removeListner(listnerId: lid)
		}
	}

	public var dataTable: CNTable {
		get           { return mDataTable			}
		set(newtable) {
			/* Remove current listner */
			if let lid = mDataListnerId {
				mDataTable.removeListner(listnerId: lid)
				mDataListnerId = nil
			}
			/* Replace by new table */
			mDataTable = newtable
			mDataListnerId = mDataTable.addListner(listner: {
				(_ events: Array<CNTableEvent>) -> Void in
				self.execute(events: events)
			})
			self.reload()
		}
	}

	static private func allocateEmptyTable() -> CNTable {
		/* Allocate dummy storage defined at "dummy-table-storage.json" */
		if let packdir = CNFilePath.URLForResourceDirectory(directoryName: "Data", subdirectory: nil, forClass: KCTableViewCore.self) {
			let packfile  = packdir.appendingPathComponent("dummy-table-storage.json")
			let cachedir  = CNFilePath.URLforApplicationSupportDirectory(subDirectory: "Data")
			let cachefile = cachedir.appendingPathComponent("dummy-table-storage.json")
			if FileManager.default.copyFileIfItIsNotExist(sourceFile: packfile, destinationFile: cachefile) {
				let storage = CNValueStorage(sourceDirectory: packdir, cacheDirectory: cachedir, filePath: "dummy-table-storage.json")
				switch storage.load() {
				case .ok(_):
					let path    = CNValuePath(elements: [.member("root")])
					let table   = CNValueTable(path: path, valueStorage: storage)
					return table
				case .error(let err):
					CNLog(logLevel: .error, message: "Failed to load dummy table storage: \(err.toString())", atFunction: #function, inFile: #file)
				@unknown default:
					CNLog(logLevel: .error, message: "Unexpected result", atFunction: #function, inFile: #file)
				}
			}
		}
		fatalError("No built-in resource")
	}

	public var visibleRowCount: Int {
		get      { return mVisibleRowCount }
		set(cnt) { mVisibleRowCount = cnt }
	}

	public var visibleFieldCount: Int { get {
		if mActiveFieldNames.count > 0 {
			return mActiveFieldNames.count
		} else {
			return mDataTable.allFieldNames.count
		}
	}}

	private var columnNames: Array<ActiveFieldName> { get {
		if mActiveFieldNames.count > 0 {
			return mActiveFieldNames
		} else {
			let fnames = mDataTable.allFieldNames
			var result: Array<ActiveFieldName> = []
			for fname in fnames {
				result.append(ActiveFieldName(field: fname, title: fname))
			}
			return result
		}
	}}

	private func columnName(atIndex idx: Int) -> ActiveFieldName? {
		if mActiveFieldNames.count > 0 {
			if 0<=idx && idx<mActiveFieldNames.count {
				return mActiveFieldNames[idx]
			} else {
				return nil
			}
		} else {
			if let fname = mDataTable.fieldName(at: idx) {
				return ActiveFieldName(field: fname, title: fname)
			} else {
				return nil
			}
		}
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

		if 0<=rowidx && rowidx < mDataTable.recordCount {
			if let colname = columnName(atIndex: colidx) {
				if let cbfunc = self.cellClickedCallback {
					cbfunc(double, colname.field, rowidx)
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

		mDataListnerId = mDataTable.addListner(listner: {
			(_ events: Array<CNTableEvent>) -> Void in
			self.execute(events: events)
		})

		reload()
	}

	private func execute(events evts: Array<CNTableEvent>) {
		for evt in evts {
			switch evt {
			case .addRecord(let row):
				CNLog(logLevel: .debug, message: "addRecord(\(row))", atFunction: #function, inFile: #file)
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in self.reload()
				})
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown event", atFunction: #function, inFile: #file)
			}
		}
	}

	/*
	 * Table
	 */
	public var numberOfRows: Int 	{ get { return mDataTable.recordCount 		}}
	public var numberOfColumns: Int { get { return self.visibleFieldCount		}}

	public var activeFieldNames: Array<ActiveFieldName> {
		get        { return mActiveFieldNames }
		set(names) { mActiveFieldNames = names }
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

	private func reload() {
		#if os(OSX)
		CNLog(logLevel: .detail, message: "Reload table contents", atFunction: #function, inFile: #file)

		mTableView.beginUpdates()

		/* Adjust column numbers */
		let fieldnum = self.visibleFieldCount
		if fieldnum < mTableView.tableColumns.count {
			/* Remove some columns */
			let delnum = mTableView.tableColumns.count - fieldnum
			for _ in 0..<delnum {
				let col = mTableView.tableColumns[0]
				mTableView.removeTableColumn(col)

			}
		} else if fieldnum > mTableView.tableColumns.count {
			/* Append empty columns */
			for _ in mTableView.tableColumns.count..<fieldnum {
				let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "?"))
				newcol.title      = "?"
				newcol.isHidden	  = false
				mTableView.addTableColumn(newcol)
			}
		}

		/* Update column titles */
		let fnames  = self.columnNames
		let fcounts = fnames.count
		for i in 0..<fnames.count {
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

		let rcounts    = mDataTable.recordCount
		mReloadedCount = rcounts * fcounts

		update(dataState: .clean)
		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()

		mTableView.endUpdates()
		self.requireDisplay()
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
		if let col = tableColumn {
			if let rec = mDataTable.record(at: row) {
				return rec.value(ofField: col.identifier.rawValue)
			}
		}
		return CNValue.nullValue
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let val = object as? CNValue {
			if let rec = mDataTable.record(at: row) {
				if !rec.setValue(value: val, forField: col.identifier.rawValue) {
					CNLog(logLevel: .error, message: "Failed to set value", atFunction: #function, inFile: #file)
					return
				}
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

		mDataTable.sort(byDescriptors: mSortDescriptors)
		mTableView.reloadData()
	}

	public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		if self.isSelectable {
			if let cbfunc = didSelectedCallback {
				cbfunc(true) // callback
			}
			return true
		} else {
			return false
		}
	}
	#endif

	/*
	 * KCTableCellDelegate
	 */
	#if os(OSX)
	public func tableCellView(shouldEndEditing view: KCTableCellView, columnTitle title: String, rowIndex ridx: Int, value val: CNValue) {
		if let rec = mDataTable.record(at: ridx) {
			if rec.setValue(value: val, forField: title) {
				update(dataState: .dirty)
				return
			}
		}
		CNLog(logLevel: .error, message: "Failed to set value", atFunction: #function, inFile: #file)
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
		let actnum = min(mTableView.numberOfRows, mVisibleRowCount)
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
			for _ in actnum..<mVisibleRowCount {
				result.width  =  max(result.width, frame.size.width)
				result.height += frame.size.height
			}
			/* Calc for space */
			if mVisibleRowCount > 1 {
				result.height += space.height * CGFloat(mVisibleRowCount - 1)
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

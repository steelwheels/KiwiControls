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

 	public var cellClickedCallback: ((_ double: Bool, _ col: Int, _ row: Int) -> Void)? = nil
	public var hasHeader:		Bool = false
	public var isEnable:		Bool = true
	public var allowsRowSelection:	Bool = false

	public var visibleRowCount:	Int  = 20

	private var mDataState:		DataState
	private var mIsEditable:	Bool
	private var mStateListner:	StateListner?
	private var mTableInterface:	CNTable
	private var mSortDescriptors:	CNSortDescriptors
	private var mReloadedCount:	Int

	#if os(OSX)
	public override init(frame : NSRect){
		mDataState		= .clean
		mIsEditable		= false
		mStateListner		= nil
		mTableInterface		= KCTableViewCore.allocateInitialTable()
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount 		= 0
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mDataState		= .clean
		mIsEditable		= false
		mStateListner		= nil
		mTableInterface		= KCTableViewCore.allocateInitialTable()
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
		mTableInterface		= KCTableViewCore.allocateInitialTable()
		mSortDescriptors	= CNSortDescriptors()
		mReloadedCount 		= 0
		super.init(coder: coder)
	}

	static private func allocateInitialTable() -> CNValueTable {
		let table  = CNValueTable()
		let newrec = CNValueRecord()
		let _ = newrec.setValue(value: .stringValue(" "), forField: "0")
		table.append(record: newrec)
		return table
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

		let recnum = mTableInterface.recordCount
		if recnum > 0 {
			if let record = mTableInterface.record(at: 0) {
				let fldnum = record.fieldCount
				if 0<=colidx && colidx < fldnum && 0<=rowidx && rowidx < recnum {
					if let cbfunc = self.cellClickedCallback {
						cbfunc(double, colidx, rowidx)
					} else {
						CNLog(logLevel: .detail, message: "Clicked col:\(colidx) row:\(rowidx)", atFunction: #function, inFile: #file)
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

		load(table: nil)
	}

	/*
	 * Table
	 */
	public var isEditable:  Bool 	{ get { return mIsEditable	  		}}
	public var numberOfRows: Int 	{ get {
		return mTableInterface.recordCount
	}}
	public var numberOfColumns: Int { get {
		if let record = mTableInterface.record(at: 0) {
			return record.fieldCount
		} else {
			return 0
		}
	}}

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
	 * Load
	 */
	public func load(table tbl: CNTable?) {
		#if os(OSX)
		CNLog(logLevel: .detail, message: "Reload table contents", atFunction: #function, inFile: #file)

		if let newtbl = tbl {
			mTableInterface = newtbl
		}

		mTableView.beginUpdates()

		/* Remove current columns */
		while mTableView.tableColumns.count > 0 {
			let col = mTableView.tableColumns[0]
			mTableView.removeTableColumn(col)
		}

		/* Add columns */
		if let record = mTableInterface.record(at: 0) {
			for name in record.fieldNames {
				let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: name))
				newcol.title      = name
				newcol.isHidden	  = false
				newcol.isEditable = mIsEditable
				mTableView.addTableColumn(newcol)
			}
		}

		if hasHeader {
			mTableView.headerView = NSTableHeaderView()
		} else {
			mTableView.headerView = nil
		}

		mTableView.endUpdates()

		if let record = mTableInterface.record(at: 0) {
			mReloadedCount = mTableInterface.recordCount * record.fieldCount
		} else {
			mReloadedCount = 0
		}

		update(dataState: .clean)
		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()
		#endif
	}

	public func save(){
		mTableInterface.save()
	}

	/*
	 * KCTableViewDataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		return mTableInterface.recordCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		if let col = tableColumn {
			if let record = mTableInterface.record(at: row) {
				if let val = record.value(ofField: col.title) {
					return val
				}
			}
		}
		CNLog(logLevel: .error, message: "No value", atFunction: #function, inFile: #file)
		return CNNativeValue.nullValue
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn, let val = object as? CNNativeValue {
			if let record = mTableInterface.record(at: row) {
				if record.setValue(value: val, forField: col.title) {
					CNLog(logLevel: .error, message: "Failed to set object value", atFunction: #function, inFile: #file)
				}
				return
			}
		}
		CNLog(logLevel: .error, message: "Failed to set object value", atFunction: #function, inFile: #file)
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mTableInterface.recordCount
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
				notify(viewControlEvent: .updateSize)
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

		mTableInterface.sort(byDescriptors: mSortDescriptors)
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
	public func tableCellView(shouldEndEditing view: KCTableCellView, columnTitle title: String, rowIndex ridx: Int, value val: CNNativeValue) {
		if let record = mTableInterface.record(at: ridx) {
			if record.setValue(value: val, forField: title) {
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

	public override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
	}

	public override var intrinsicContentSize: KCSize {
		#if os(OSX)
		let size: KCSize
		if let sz = calcContentSize() {
			size = sz
		} else {
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
		if rownum > 0 {
			for ridx in 0..<rownum {
				if let rview = mTableView.rowView(atRow: ridx, makeIfNecessary: false) {
					let frame = rview.frame
					result.width  =  max(result.width, frame.size.width)
					result.height += frame.size.height
				}
			}
			if rownum > 1 {
				result.height += space.height * CGFloat(rownum - 1)
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
		NSLog("tableView: \(mTableView.frame.description)")
		for cidx in 0..<numberOfColumns {
			for ridx in 0..<numberOfRows {
				NSLog("cidx:\(cidx)/ridx:\(ridx)")
				if let cell = mTableView.view(atColumn: cidx, row: ridx, makeIfNecessary: false) {
					NSLog(" frame: \(cell.frame.description)")
				}
			}
		}
		#endif
	}
}


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

open class KCTableViewCore : KCCoreView, KCTableViewDelegate, KCTableViewDataSource
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	// [double] true: double click, false: single click
 	public var cellClickedCallback: ((_ double: Bool, _ col: Int, _ row: Int) -> Void)? = nil
	public var hasHeader:		Bool = false
	public var isEditable:		Bool = false
	public var isEnable:		Bool = true
	public var allowsRowSelection:	Bool = false

	public var visibleRowCount:	Int  = 20

	private var mTableInterface:	CNNativeTableInterface
	private var mReloadedCount:	Int

	#if os(OSX)
	public override init(frame : NSRect){
		mTableInterface	= CNNativeValueTable()
		mReloadedCount  = 0
		super.init(frame: frame)
		self.initValueTable(table: mTableInterface)
	}
	#else
	public override init(frame: CGRect){
		mTableInterface	= CNNativeValueTable()
		mReloadedCount  = 0
		super.init(frame: frame)
		self.initValueTable(table: mTableInterface)
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
		mReloadedCount  = 0
		super.init(coder: coder)
		self.initValueTable(table: mTableInterface)
	}

	private func initValueTable(table tbl: CNNativeTableInterface){
		tbl.setValue(columnIndex: .number(0), row: 0, value: .stringValue(""))
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
		let colnum = mTableInterface.columnCount
		let rownum = mTableInterface.rowCount
		if 0<=colidx && colidx < colnum && 0<=rowidx && rowidx < rownum {
			if let cbfunc = self.cellClickedCallback {
				cbfunc(double, colidx, rowidx)
			} else {
				NSLog("Clicked col:\(colidx) row:\(rowidx)")
			}
			if let view = mTableView.view(atColumn: colidx, row: rowidx, makeIfNecessary: false) as? KCTableCellView {
				if let resp = view.firstResponderView {
					NSLog("click -> notify")
					notify(viewControlEvent: .switchFirstResponder(resp))
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

		/* Add dummy cell */
		mTableInterface.setValue(columnIndex: .number(0), row: 0, value: .nullValue)

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

		reload(table: nil)
	}

	/*
	 * Table
	 */
	public var numberOfColumns: Int { get { return mTableInterface.columnCount }}
	public var numberOfRows: Int 	{ get { return mTableInterface.rowCount    }}

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
	 * Reload
	 */
	public func reload(table tbl: CNNativeTableInterface?) {
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
		for i in 0..<mTableInterface.columnCount {
			let colname       = mTableInterface.title(column: i)
			let newcol        = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: colname))
			newcol.title      = colname
			newcol.isHidden	  = false
			newcol.isEditable = true // self.isEditable
			mTableView.addTableColumn(newcol)
		}

		if hasHeader {
			mTableView.headerView = NSTableHeaderView()
		} else {
			mTableView.headerView = nil
		}

		mTableView.endUpdates()

		mReloadedCount = mTableInterface.rowCount * mTableInterface.columnCount

		mTableView.noteNumberOfRowsChanged()
		mTableView.reloadData()
		#endif
	}

	/*
	 * KCTableViewDataSource
	 */
	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		NSLog("rowCount: \(mTableInterface.rowCount)")
		return mTableInterface.rowCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		NSLog("tableView objectValueFor")
		if let col = tableColumn {
			let val = mTableInterface.value(columnIndex: .title(col.title), row: row)
			NSLog(" -> value: \(val.toText().toStrings().joined()) forColumn: \(col.title) forRow: \(row)")

			switch val {
			case .nullValue:
				return nil
			default:
				return val
			}
		} else {
			CNLog(logLevel: .error, message: "tableView: Not column", atFunction: #function, inFile: #file)
		}
		return nil
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		NSLog("tableView setObjectValue")
		if let col = tableColumn, let val = object as? CNNativeValue {
			NSLog("tableView setObjectValue -> \(val.toText().toStrings().joined())")
			mTableInterface.setValue(columnIndex: .title(col.title), row: row, value: val)
		} else {
			NSLog("Failed to set object value")
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
		NSLog("makeView: \(String(describing: tableColumn)) \(ridx)")
		let newview = mTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "tableCellView"), owner: mTableView)
		if let cell = newview as? KCTableCellView {
			NSLog(" -> is KCTableCellView")
			cell.isEnabled  = self.isEnable
			cell.isEditable = self.isEditable
		} else {
			NSLog("[Error] Unexpected cell view")
		}
		if mReloadedCount > 0 {
			mReloadedCount -= 1
			if mReloadedCount == 0 {
				NSLog("Reloaded ... Notify resize")
				self.invalidateIntrinsicContentSize()
				self.requireLayout()
				notify(viewControlEvent: .updateSize)
			}
		}
		return newview
	}

	public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return self.allowsRowSelection
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

	public override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		NSLog("setFrameSize: \(newsize.description)")
	}

	public override var intrinsicContentSize: KCSize {
		#if os(OSX)
		let size = calcContentSize()
		#else
		let size = super.intrinsicContentSize
		#endif
		NSLog("intrinsicContentsSize: \(size.description)")
		return size
	}

	#if os(OSX)
	private func calcContentSize() -> KCSize {
		var result = KCSize.zero
		let space  = mTableView.intercellSpacing
		if let header = mTableView.headerView {
			result        =  header.frame.size
			result.height += space.height
		}
		let rownum = min(mTableView.numberOfRows, visibleRowCount)
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
	}
	#endif

	public var firstResponderView: KCViewBase? { get {
		#if os(OSX)
		let row = mTableView.clickedRow
		let col = mTableView.clickedColumn
		NSLog("firstResonderView: \(row) \(col)")
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
		NSLog("DUMP")
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


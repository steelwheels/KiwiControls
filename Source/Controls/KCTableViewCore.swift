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

public protocol KCTableDelegate {
	var columnCount: Int 	{ get }
	var rowCount:	 Int	{ get }

	func title(column index: Int) -> String

	func set(colmunName cname: String, rowIndex ridx: Int, data dat: Any?)

	func view(colmunName  cname: String, rowIndex ridx: Int) -> KCView?
	func view(colmunIndex cidx: Int, rowIndex ridx: Int) -> KCView?
}

public class KCDefaultTableData: KCTableDelegate
{
	public var data:	Any?	= nil

	public var columnCount:	Int { return 1 }
	public var rowCount:	Int { return 1 }

	public func title(column index: Int) -> String {
		return "\(index)"
	}

	public func set(colmunName cname: String, rowIndex ridx: Int, data dat: Any?){
		self.data = dat
	}

	public func view(colmunName  cname: String, rowIndex ridx: Int) -> KCView? {
		if cname == "0" && ridx == 0 {
			let frame = KCRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
			return KCTextView(frame: frame)
		} else {
			return nil
		}

	}

	public func view(colmunIndex cidx: Int, rowIndex ridx: Int) -> KCView? {
		if cidx == 0 && ridx == 0 {
			let frame = KCRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0)
			return KCTextView(frame: frame)
		} else {
			return nil
		}
	}
}

open class KCTableViewCore : KCView, KCTableViewDelegate, KCTableViewDataSource
{
	#if os(OSX)
	@IBOutlet weak var mTableView: NSTableView!
	#else
	@IBOutlet weak var mTableView: UITableView!
	#endif

	private var	mTableDelegate: 	KCTableDelegate
	public var 	cellPressedCallback: 	((_ col: Int, _ row: Int) -> Void)? = nil

	#if os(OSX)
	public override init(frame : NSRect){
		mTableDelegate = KCDefaultTableData()
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mTableDelegate = KCDefaultTableData()
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
		mTableDelegate = KCDefaultTableData()
		super.init(coder: coder)
	}

	public var tableDelegate: KCTableDelegate {
		get      { return mTableDelegate }
		set(dlg) {
			mTableDelegate = dlg
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				self.updateContents()
			})
		}
	}

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

	public func updateContents(){
		#if os(OSX)

		mTableView.beginUpdates()

		/* Remove current columns */
		while mTableView.tableColumns.count > 0 {
			let col = mTableView.tableColumns[0]
			mTableView.removeTableColumn(col)
		}

		/* Add columns */
		let colnum = mTableDelegate.columnCount
		for i in 0..<colnum {
			let colname = mTableDelegate.title(column: i)
			let newcol = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: colname))
			newcol.title      = colname
			newcol.isEditable = false
			mTableView.addTableColumn(newcol)
		}

		mTableView.endUpdates()

		mTableView.reloadData()
		self.invalidateIntrinsicContentSize()
		self.setNeedsDisplay()
		#endif
	}

	#if os(OSX)
	@objc func doubleClicked(sender: AnyObject) {
		let rowidx = mTableView.clickedRow
		let colidx = mTableView.clickedColumn
		if let cbfunc = self.cellPressedCallback {
			let colnum = mTableDelegate.columnCount
			let rownum = mTableDelegate.rowCount
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
	public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let col = tableColumn {
			return mTableDelegate.view(colmunName: col.title, rowIndex: row)
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
		return mTableDelegate.rowCount
	}

	public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
		if let col = tableColumn {
			return mTableDelegate.view(colmunName: col.title, rowIndex: row)
		} else {
			CNLog(logLevel: .error, message: "No valid column")
			return nil
		}
	}

	public func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		if let col = tableColumn {
			mTableDelegate.set(colmunName: col.title, rowIndex: row, data: object)
		} else {
			CNLog(logLevel: .error, message: "No valid column")
		}
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mTableDelegate.rowCount
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
		let space = mTableView.intercellSpacing
		var result: KCSize = KCSize.zero
		for cidx in 0..<mTableView.numberOfColumns {
			var width:  CGFloat = 0.0
			var height: CGFloat = 0.0
			for ridx in 0..<mTableView.numberOfRows {
				if let view = mTableView.view(atColumn: cidx, row: ridx, makeIfNecessary: false) {
					let fsize = view.intrinsicContentSize
					NSLog("KCTableView: \(cidx) \(ridx) \(fsize.description)")
					width  =  max(width, fsize.width + space.width)
					height += fsize.height + space.height
				}
			}
			result.width  += width
			result.height =  max(result.height, height)
		}
		NSLog("KCTableView: intrinsicContentSize=\(result.description)")
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


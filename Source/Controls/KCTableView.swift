/**
 * @file	KCTableView.swift
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTableView : KCInterfaceView
{
	public typealias FieldName	= KCTableViewCore.FieldName
	public typealias FilterFunction	= CNMappingTable.FilterFunction

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setup() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setup()
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 272)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 375)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}

	public var numberOfRows:	Int { get { return coreView.numberOfRows	}}
	public var numberOfColumns:	Int { get { return coreView.numberOfColumns	}}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCTableView.self, nibName: "KCTableViewCore") as? KCTableViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTableViewCore")
		}
	}

	public var dataTable: CNTable {
		get         { return coreView.dataTable }
		set(newtbl) { coreView.dataTable = newtbl }
	}

	public var filterFunction: FilterFunction? {
		get         { return coreView.filterFunction   }
		set(newval) { coreView.filterFunction = newval }
	}

	public var fieldNames: Array<FieldName> {
		get	 { return coreView.fieldNames }
		set(val) { coreView.fieldNames = val  }
	}

	public var sortOrder: CNSortOrder {
		get 	 { return coreView.sortOrder	}
		set(val) { coreView.sortOrder = val     }
	}

	public var hasHeader: Bool {
		get         { return coreView.hasHeader }
		set(newval) { coreView.hasHeader = newval }
	}

	public var hasGrid: Bool {
		get         { return coreView.hasGrid }
		set(newval) { coreView.hasGrid = newval }
	}

	public var isEnable: Bool {
		get         { return coreView.isEnable }
		set(newval) { coreView.isEnable = newval }
	}

	public var isEditable: Bool {
		get         { return coreView.isEditable }
		set(newval) { coreView.isEditable = newval }
	}

	public var minimumVisibleRowCount: Int {
		get         { return coreView.minimumVisibleRowCount }
		set(newval) { coreView.minimumVisibleRowCount = newval }
	}

	public func addVirtualField(name field: String, callbackFunction cbfunc: @escaping CNMappingTable.VirtualFieldCallback) {
		coreView.addVirtualField(name: field, callbackFunction: cbfunc)
	}

	public var compareFunction: KCTableViewCore.CompareFunction? {
		get         { return coreView.compareFunction    }
		set(newval) { coreView.compareFunction  = newval }
	}

	public func reload() {
		coreView.reload()
	}

	public func selectedRecords() -> Array<CNRecord> {
		return coreView.selectedRecords()
	}

	public func removeSelectedRows() {
		coreView.removeSelectedRows()
	}

	public var firstResponderView: KCViewBase? { get {
		return coreView.firstResponderView
	}}

	public func view(atColumn col: Int, row rw: Int) -> KCViewBase? {
		return coreView.view(atColumn: col, row: rw)
	}

	public var cellClickedCallback: KCTableViewCore.ClickCallbackFunction? {
		get         { return coreView.cellClickedCallback   }
		set(cbfunc) { coreView.cellClickedCallback = cbfunc }
	}

	public var didSelectedCallback: ((_ selected: Bool) -> Void)? {
		get         { return coreView.didSelectedCallback   }
		set(cbfunc) { coreView.didSelectedCallback = cbfunc }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(tableView: self)
	}

	private var coreView: KCTableViewCore {
		get { return getCoreView() }
	}
}



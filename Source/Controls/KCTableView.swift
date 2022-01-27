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
	public typealias ActiveFieldName = KCTableViewCore.ActiveFieldName
	public typealias StateListner    = KCTableViewCore.StateListner
	public typealias DataState       = KCTableViewCore.DataState

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

	public var hasGrid: Bool {
		get		{ return coreView.hasGrid }
		set(newval)	{ coreView.hasGrid = true}
	}

	public var stateListner: StateListner? {
		get		{ return coreView.stateListner }
		set(listner)	{ coreView.stateListner = listner}
	}

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

	public var visibleRowCount: Int {
		get      { return coreView.visibleRowCount }
		set(cnt) { coreView.visibleRowCount = cnt  }
	}

	open func store(table tblp: CNTable?){
		self.coreView.store(table: tblp)
	}

	open func store(dictionary dictp: Dictionary<String, CNValue>?){
		self.coreView.store(dictionary: dictp)
	}

	public func loadTable() -> CNTable? {
		return self.coreView.loadTable()
	}

	public func loadDictionary() -> Dictionary<String, CNValue>? {
		return self.coreView.loadDictionary()
	}

	public var isEnable: Bool {
		get      { return coreView.isEnable }
		set(val) { coreView.isEnable = val }
	}

	public var activeFieldNames: Array<ActiveFieldName> {
		get        { return coreView.activeFieldNames  }
		set(names) { coreView.activeFieldNames = names }
	}

	public var hasHeader: Bool {
		get 	{ return coreView.hasHeader	}
		set(val){ coreView.hasHeader = val	}
	}

	public var isSelectable: Bool {
		get      { return coreView.isSelectable }
		set(val) { coreView.isSelectable = val  }
	}

	public var firstResponderView: KCViewBase? { get {
		return coreView.firstResponderView
	}}

	public func view(atColumn col: Int, row rw: Int) -> KCViewBase? {
		return coreView.view(atColumn: col, row: rw)
	}

	public var cellClickedCallback: ((_ double: Bool, _ colname: String, _ rowidx: Int) -> Void)? {
		get         { return coreView.cellClickedCallback   }
		set(cbfunc) { coreView.cellClickedCallback = cbfunc }
	}

	public var didSelectedCallback: ((_ selected: Bool) -> Void)? {
		get         { return coreView.didSelectedCallback   }
		set(cbfunc) { coreView.didSelectedCallback = cbfunc }
	}

	public func dump(){
		coreView.dump()
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(tableView: self)
	}

	private var coreView: KCTableViewCore {
		get { return getCoreView() }
	}
}



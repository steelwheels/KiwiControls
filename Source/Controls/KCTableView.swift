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

	public var numberOfColumns: Int { get { return coreView.numberOfColumns }}
	public var numberOfRows: Int 	{ get { return coreView.numberOfRows    }}

	public var hasGrid: Bool {
		get		{ return coreView.hasGrid }
		set(newval)	{ coreView.hasGrid = true}
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

	open func reload(table tbl: CNNativeTableInterface?) {
		self.coreView.reload(table: tbl)
	}

	public var isEditable: Bool {
		get      { return coreView.isEditable }
		set(val) { coreView.isEditable = val }
	}

	public var hasHeader: Bool {
		get 	{ return coreView.hasHeader	}
		set(val){ coreView.hasHeader = val	}
	}

	public var firstResponderView: KCViewBase? { get {
		return coreView.firstResponderView
	}}

	public func view(atColumn col: Int, row rw: Int) -> KCView? {
		return coreView.view(atColumn: col, row: rw)
	}

	public var cellClickedCallback: ((_ double: Bool, _ col: Int, _ row: Int) -> Void)? {
		get         { return coreView.cellClickedCallback   }
		set(cbfunc) { coreView.cellClickedCallback = cbfunc }
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



/**
 * @file	KCTableView.swift
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTableView : KCCoreView
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

	public var cellTable: KCCellTableInterface? {
		get	  { return coreView.cellTable	}
		set(strg) { coreView.cellTable = strg	}
	}

	public var numberOfVisibleColmuns: Int {
		get         { return coreView.numberOfVisibleColmuns}
		set(newval) { coreView.numberOfVisibleColmuns = newval }
	}

	public var numberOfVisibleRows: Int {
		get         { return coreView.numberOfVisibleRows}
		set(newval) { coreView.numberOfVisibleRows = newval }
	}

	public var cellPressedCallback: ((_ column: String, _ row: Int) -> Void)? {
		get         { return coreView.cellPressedCallback   }
		set(cbfunc) { coreView.cellPressedCallback = cbfunc }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(tableView: self)
	}

	private var coreView: KCTableViewCore {
		get { return getCoreView() }
	}
}



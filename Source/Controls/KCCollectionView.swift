/**
 * @file	KCCollectionView.swift
 * @brief	Define KCCollectionView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

open class KCCollectionView: KCInterfaceView
{
	public typealias SelectionCallback = KCCollectionViewCore.SelectionCallback

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame)
		setup(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame)
		setup(frame: frame)
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 188, height: 21)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup(frame: self.frame)
	}

	private func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCCollectionView.self, nibName: "KCCollectionViewCore") as? KCCollectionViewCore {
			setCoreView(view: newview)
			newview.setup(frame: frm)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCCollectionViewCore")
		}
	}

	public var numberOfColumuns: Int {
		get         { return coreView.numberOfColumuns }
		set(newval) { coreView.numberOfColumuns = newval }
	}

	public var numberOfSections: Int { get { return coreView.numberOfSections }}

	public func numberOfItems(inSection sec: Int) -> Int? {
		return coreView.numberOfItems(inSection: sec)
	}

	public var isSelectable: Bool {
		get         { return coreView.isSelectable }
		set(newval) { coreView.isSelectable = newval }
	}

	public var selectedItems: Set<IndexPath> {
		get 	    { return coreView.selectedItems   }
	}

	public func selectItem(indexPath path: IndexPath){
		coreView.selectItem(indexPath: path)
	}

	public func set(selectionCallback cbfunc: @escaping SelectionCallback) {
		coreView.set(selectionCallback: cbfunc)
	}

	public func store(data dat: CNCollection){
		coreView.store(data: dat)
	}

	public var firstResponderView: KCViewBase? { get {
		return coreView.firstResponderView
	}}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(collectionView: self)
	}

	private var coreView: KCCollectionViewCore {
		get { return getCoreView() }
	}
}


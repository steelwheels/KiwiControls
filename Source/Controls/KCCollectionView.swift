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
	public typealias SelectedCallback = KCCollectionViewCore.SelectedCallback

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

	public var numberOfSections: Int { get { return coreView.numberOfSections }}

	public func numberOfItems(inSection sec: Int) -> Int? {
		return coreView.numberOfItems(inSection: sec)
	}

	public func store(data dat: CNCollection){
		coreView.store(data: dat)
	}

	public var isSelectable: Bool {
		get         { return coreView.isSelectable }
		set(newval) { coreView.isSelectable = newval }
	}

	public func set(callback cbfunc: @escaping SelectedCallback) {
		coreView.set(callback: cbfunc)
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


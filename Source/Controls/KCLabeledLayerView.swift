/**
 * @file	KCLabeledLayerView.swift
 * @brief	Define KCLabeledLayerView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif

open class KCLabeledLayerView: KCCoreView
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
			let frame = CGRect(x: 0.0, y: 0.0, width: 256, height: 256)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCLabeledLayerView.self, nibName: "KCLabeledLayerViewCore") as? KCLabeledLayerViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)

		} else {
			fatalError("Can not load KCLabeledLayerViewCore")
		}
	}

	public var imageDrawer: KCImageDrawer? {
		get { return coreView.imageDrawer }
		set(drawer){ coreView.imageDrawer = drawer }
	}

	public var label: String {
		get { return coreView.label }
		set(str){ coreView.label = str }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(iconView: self)
	}

	private var coreView: KCLabeledLayerViewCore {
		get { return super.getCoreView() }
	}
}
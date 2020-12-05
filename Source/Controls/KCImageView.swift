/**
 * @file KCImageView.swift
 * @brief Define KCImageView class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

open class KCImageView: KCCoreView
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
		let frame = NSRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCImageViewCore.self, nibName: "KCImageViewCore") as? KCImageViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCImageViewCore")
		}
	}

	public func set(image img: CNImage) {
		coreView.set(image: img)
	}

	public var imageSize: CGSize {
		get { return coreView.imageSize }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(imageView: self)
	}

	private var coreView: KCImageViewCore {
		get { return getCoreView() }
	}
}


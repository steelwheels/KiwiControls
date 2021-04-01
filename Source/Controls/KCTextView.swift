/**
 * @file	KCTextView.swift
 * @brief	Define KCTextView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

open class KCTextView : KCCoreView
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

	public var isEditable: Bool {
		get         { return coreView.isEditable   }
		set(newval) { coreView.isEditable = newval }
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCTextView.self, nibName: "KCTextViewCore") as? KCTextViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTextViewCore")
		}
	}

	public func execute(escapeCodes codes: Array<CNEscapeCode>) {
		coreView.execute(escapeCodes: codes)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(textView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}


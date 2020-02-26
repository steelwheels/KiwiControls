/**
 * @file	KCTerminalView.swift
 * @brief Define KCTerminalView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTerminalView : KCCoreView
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
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 22)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}

	public var inputFileHandle: FileHandle {
		get { return coreView.inputFileHandle }
	}

	public var outputFileHandle: FileHandle {
		get { return coreView.outputFileHandle }
	}

	public var errorFileHandle: FileHandle {
		get { return coreView.errorFileHandle }
	}

	public var foregroundTextColor: KCColor? {
		get		{ return coreView.foregroundTextColor }
		set(newcol)	{ coreView.foregroundTextColor = newcol }
	}

	public var backgroundTextColor: KCColor? {
		get		{ return coreView.backgroundTextColor }
		set(newcol)	{ coreView.backgroundTextColor = newcol }
	}

	public var font: CNFont {
		get		{ return coreView.font		}
		set(newcol)	{ coreView.font = newcol	}
	}
	
	private func setup(){
		KCView.setAutolayoutMode(view: self)
		guard let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTextViewCore") as? KCTextViewCore else {
			NSLog("Failed to load resource")
			return
		}
		setCoreView(view: newview)
		newview.setup(mode: .console, frame: self.frame)
		allocateSubviewLayout(subView: newview)
	}

	public var fontPointSize: CGFloat{
		get		{ return coreView.fontPointSize		}
		set(newsize)	{ coreView.fontPointSize = newsize	}
	}

	public var currentColumnNumbers: Int {
		get { return coreView.currentColumnNumbers }
		set(newnum){ coreView.currentColumnNumbers = newnum }
	}

	public var currentRowNumbers: Int {
		get { return coreView.currentRowNumbers }
		set(newnum){ coreView.currentRowNumbers = newnum }
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.Low, .Low)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(terminalView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}


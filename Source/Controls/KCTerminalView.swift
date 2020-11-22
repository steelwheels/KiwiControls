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

	public var foregroundTextColor: CNColor {
		get		{ return coreView.foregroundTextColor }
	}

	public var backgroundTextColor: CNColor {
		get		{ return coreView.backgroundTextColor }
	}
	
	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTerminalViewCore") as? KCTerminalViewCore  {
			setCoreView(view: newview)
			newview.setup(mode: .console, frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Failed to load resource")
		}
	}

	public var font: CNFont {
		get { return coreView.font	}
	}

	public var width: Int {
		get { return coreView.width }
	}

	public var height: Int {
		get { return coreView.height }
	}

	#if os(OSX)
	open override func setFrameSize(_ newSize: NSSize) {
		//NSLog("NSTerminalView: setFrameSize \(newSize.description)")
		super.setFrameSize(newSize)
	}

	open override func setBoundsSize(_ newSize: NSSize) {
		//NSLog("setBoudsSize")
		super.setBoundsSize(newSize)
	}
	#endif

	/*public func leftTopOffset() -> Int {
		return coreView.leftTopOffset()
	}*/

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(terminalView: self)
	}

	private var coreView: KCTerminalViewCore {
		get { return getCoreView() }
	}
}


/**
 * @file	KCConsoleView.swift
 * @brief Define KCConsoleView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCConsoleView : KCCoreView
{
	private var mConsole:	CNFileConsole?	= nil

	public var foregroundTextColor: CNColor {
		get		{ return coreView.foregroundTextColor }
		set(newcol)	{ coreView.foregroundTextColor = newcol }
	}

	public var backgroundTextColor: CNColor {
		get		{ return coreView.backgroundTextColor }
		set(newcol)	{ coreView.backgroundTextColor = newcol }
	}
	
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
		setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}
	
	public var consoleConnection: CNFileConsole {
		get {
			if let cons = mConsole {
				return cons
			} else {
				let newcons = CNFileConsole(input:  coreView.inputFileHandle,
							    output: coreView.outputFileHandle,
							    error:  coreView.errorFileHandle)
				mConsole = newcons
				return newcons
			}
		}
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCConsoleView.self, nibName: "KCTextViewCore") as? KCTextViewCore  {
			setCoreView(view: newview)
			newview.setup(mode: .log, frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			NSLog("Failed to load resource")
			return
		}
	}
	
	public var font: CNFont {
		get		{ return coreView.font	}
		set(newfont)	{ coreView.font = newfont }
	}

	public func clear(){
		let code = CNEscapeCode.eraceEntireBuffer.encode()
		if let cons = mConsole {
			cons.print(string: code)
		}
	}

	public var currentColumnNumbers: Int {
		get { return coreView.currentColumnNumbers }
		set(newnum){ coreView.currentColumnNumbers = newnum }
	}

	public var currentRowNumbers: Int {
		get { return coreView.currentRowNumbers }
		set(newnum){ coreView.currentRowNumbers = newnum }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(consoleView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}

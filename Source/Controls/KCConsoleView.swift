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

	public var textColor: KCColor? {
		get		{ return coreView.textColor }
		set(newcol)	{ coreView.textColor = newcol }
	}

	#if os(OSX)
	public var backgroundColor: KCColor? {
		get		{ return coreView.backgroundColor }
		set(newcol)	{ coreView.backgroundColor = newcol }
	}
	#else
	public override var backgroundColor: KCColor? {
		get		{ return coreView.backgroundColor }
		set(newcol)	{
			coreView.backgroundColor = newcol
			super.backgroundColor = newcol
		}
	}
	#endif
	
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setupContext()
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 22)
		#endif
		self.init(frame: frame)
		setupContext()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
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

	private func setupContext(){
		guard let newview = loadChildXib(thisClass: KCConsoleView.self, nibName: "KCTextViewCore") as? KCTextViewCore else {
			NSLog("Failed to load resource")
			return
		}
		setCoreView(view: newview)
		newview.setup(mode: .log, frame: self.frame)
		allocateSubviewLayout(subView: newview)
	}

	public var font: CNFont {
		get		{ return coreView.font	}
		set(newfont)	{ coreView.font = newfont }
	}

	public var fontPointSize: CGFloat{
		get		{ return coreView.fontPointSize		}
		set(newsize)	{ coreView.fontPointSize = newsize	}
	}

	public func clear(){
		let code = CNEscapeCode.eraceEntireBuffer.encode()
		if let cons = mConsole {
			cons.print(string: code)
		}
	}

	public var columnNumbers: Int {
		get { return coreView.columnNumbers }
	}

	public var lineNumbers: Int {
		get { return coreView.lineNumbers }
	}

	public var minimumColumnNumbers: Int {
		get { return coreView.minimumColumnNumbers }
		set(newnum){ coreView.minimumColumnNumbers = newnum }
	}

	public var minimumLineNumbers: Int {
		get { return coreView.minimumLineNumbers }
		set(newnum){ coreView.minimumLineNumbers = newnum }
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.Low, .Low)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(consoleView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}

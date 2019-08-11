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

public class KCTerminal: CNConsole
{
	private var mOwnerView:	KCTerminalView

	public init(ownerView owner: KCTerminalView){
		mOwnerView = owner
	}

	public func print(string str: String){
		mOwnerView.appendText(normal: str)
	}

	public func error(string str: String){
		mOwnerView.appendText(error: str)
	}

	public func scan() -> String? {
		return nil
	}
}

open class KCTerminalView : KCCoreView, NSTextStorageDelegate
{
	private var mConsoleConnection: KCTerminal? = nil
	private var mTextStorage: KCTextStorage?    = nil

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

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTextViewCore") as? KCTextViewCore {
			mConsoleConnection = KCTerminal(ownerView: self)
			setCoreView(view: newview)
			let storage = KCTextStorage(coreView: coreView)
			mTextStorage = storage
			newview.setup(type: .terminal, delegate: storage, frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTextViewCore")
		}
	}

	public var minimumColumnNumbers: Int {
		get { return coreView.minimumColumnNumbers }
		set(newnum){ coreView.minimumColumnNumbers = newnum}
	}

	public var minimumLineNumbers: Int {
		get { return coreView.minimumLineNumbers }
		set(newnum){ coreView.minimumLineNumbers = newnum }
	}

	public var columnNumbers: Int {
		get { return coreView.columnNumbers }
	}

	public var lineNumbers: Int {
		get { return coreView.lineNumbers }
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.Low, .Low)
	}

	public var consoleConnection: CNConsole {
		get { return mConsoleConnection! }
	}

	public func appendText(normal str: String){
		coreView.appendText(normal: str)
	}

	public func appendText(error str: String){
		coreView.appendText(error: str)
	}

	public func clear(){
		coreView.clear()
	}

	public var color: KCTextColor {
		get	 { return coreView.color }
		set(col) { coreView.color = col}
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(terminalView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}



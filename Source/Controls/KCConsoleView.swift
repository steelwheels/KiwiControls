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

/*
public class KCConsole: CNConsole
{
	private var mOwnerView:	KCConsoleView

	public init(ownerView owner: KCConsoleView){
		mOwnerView = owner
	}

	public func print(string str: String){
		mOwnerView.appendText(normal: str)
	}

	public func error(string str: String){
		mOwnerView.appendText(error: str)
	}

	private func attributedString(string str: String, foregroundColor fgcolor: KCColor) -> NSAttributedString {
		let bgcolor = mOwnerView.color.backgroundColor
		let attrs: [KCStringAttribute] = [.foregroundColor(fgcolor), .backgroundColor(bgcolor)]
		return NSAttributedString(string: str, stringAttributes: attrs)
	}

	public func scan() -> String? {
		return nil
	}
}
*/

open class KCConsoleView : KCCoreView
{
	private var mPipeConsole:		CNPipeConsole

	public var consoleConnection: CNFileConsole {
		get { return mPipeConsole.interfaceConsole }
	}

	#if os(OSX)
	public override init(frame : NSRect){
		mPipeConsole = CNPipeConsole()
		super.init(frame: frame)
		setupContext()
		setupHandlers()
	}
	#else
	public override init(frame: CGRect){
		mPipeConsole = CNPipeConsole()
		super.init(frame: frame)
		setupContext()
		setupHandlers()
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
		mPipeConsole = CNPipeConsole()
		super.init(coder: coder) ;
		setupContext()
		setupHandlers()
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCConsoleView.self, nibName: "KCTextViewCore") as? KCTextViewCore {
			setCoreView(view: newview)
			newview.setup(type: .console, frame: self.frame, output: nil)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTextViewCore")
		}
	}

	private func setupHandlers() {
		mPipeConsole.inputHandler = nil
		mPipeConsole.outputHandler = {
			(_ str: String) -> Void in
			self.appendText(normal: str)
		}
		mPipeConsole.errorHandler = {
			(_ str: String) -> Void in
			self.appendText(error: str)
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
		vis.visit(consoleView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}

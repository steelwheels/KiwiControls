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
import CoconutShell

open class KCTerminalView : KCCoreView, NSTextStorageDelegate
{
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
			setCoreView(view: newview)
			newview.setup(type: .terminal, frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTextViewCore")
		}
	}

	public var shellInterface: CNShellInterface? {
		get {
			if let vdlg = coreView.textViewDelegate as? KCTerminalViewDelegates {
				return vdlg.shellInterface
			} else {
				NSLog("[Error] Failed to get terminal delegate")
				return nil
			}
		}
		set(newintf){
			if let vdlg = coreView.textViewDelegate as? KCTerminalViewDelegates {
				if let intf = newintf {
					/* Connect stdout */
					intf.output.setReader(handler: {
						[weak self] (_ str: String) -> Void in
						if let myself = self {
							myself.insertText(normal: str, delegate: vdlg)
						}
					})

					/* Connect stderr */
					intf.error.setReader(handler: {
						[weak self] (_ str: String) -> Void in
						if let myself = self {
							myself.insertText(error: str, delegate: vdlg)
						}
					})
				}
				vdlg.shellInterface = newintf
			} else {
				NSLog("[Error] Failed to set terminal delegate")
			}
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

	public func insertText(normal str: String, delegate dlg: KCTerminalViewDelegates){
		coreView.insertText(normal: str, before: KCTextViewCore.INSERTION_POINT)
	}

	public func insertText(error str: String, delegate dlg: KCTerminalViewDelegates){
		coreView.insertText(error: str, before: KCTextViewCore.INSERTION_POINT)
	}

	public func insertText(normal str: String, before pos: Int){
		coreView.insertText(normal: str, before: pos)
	}

	public func insertText(error str: String, before pos: Int){
		coreView.insertText(error: str, before: pos)
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



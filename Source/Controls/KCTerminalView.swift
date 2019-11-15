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

	public var inputFileHandle: FileHandle {
		get { return coreView.inputFileHandle }
	}

	public var outputFileHandle: FileHandle {
		get { return coreView.outputFileHandle }
	}

	public var errorFileHandle: FileHandle {
		get { return coreView.errorFileHandle }
	}

	private func setupContext(){
		guard let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTextViewCore") as? KCTextViewCore else {
			NSLog("Failed to load resource")
			return
		}
		setCoreView(view: newview)
		newview.setup(mode: .console, frame: self.frame)
		allocateSubviewLayout(subView: newview)
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

	public var color: KCTextColor {
		get { return coreView.color }
		set(newcol){ coreView.color = newcol }
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

/*
open class KCTerminalView : KCCoreView, NSTextStorageDelegate
{
	private var	mInputPipe: 	Pipe
	private var	mOutputPipe: 	Pipe
	private var	mErrorPipe: 	Pipe


	deinit {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil
	}

	public var inputFileHandle:	FileHandle { get { return mInputPipe.fileHandleForReading	}}
	public var ouptutFileHandle:	FileHandle { get { return mOutputPipe.fileHandleForWriting	}}
	public var errorFileHandle:	FileHandle { get { return mErrorPipe.fileHandleForWriting	}}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTextViewCore") as? KCTextViewCore {
			setCoreView(view: newview)
			newview.setup(type: .terminal, frame: self.frame, output: mInputPipe.fileHandleForWriting)
			allocateSubviewLayout(subView: newview)

			/* Connect standard output */
			mOutputPipe.fileHandleForReading.readabilityHandler = {
				[weak self] (_ hdl: FileHandle) -> Void in
				if let myself = self {
					let data = hdl.availableData
					if let str = String(data: data, encoding: .utf8) {
						myself.insertText(normal: str)
					}
				}
			}
			/* Connect standard error */
			mErrorPipe.fileHandleForReading.readabilityHandler = {
				[weak self] (_ hdl: FileHandle) -> Void in
				if let myself = self {
					let data = hdl.availableData
					if let str = String(data: data, encoding: .utf8) {
						myself.insertText(error: str)
					}
				}
			}
		} else {
			fatalError("Can not load KCTextViewCore")
		}
	}

	public var fontSize: KCSize {
		get { return coreView.fontSize() }
	}



	public func appendText(normal str: String){
		coreView.appendText(normal: str)
	}

	public func appendText(error str: String){
		coreView.appendText(error: str)
	}

	public func insertText(normal str: String){
		coreView.insertText(normal: str, before: KCTextViewCore.INSERTION_POINT)
	}

	public func insertText(error str: String){
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




}

*/


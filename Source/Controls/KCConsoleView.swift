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

open class KCConsoleView : KCTextView
{
	private var mOutputPipe:		Pipe
	private var mErrorPipe:			Pipe

	#if os(OSX)
	public override init(frame : NSRect){
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(frame: frame)
		setupObservers()
		setupFileStream()
	}
	#else
	public override init(frame: CGRect){
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(frame: frame)
		setupObservers()
		setupFileStream()
	}
	#endif

	public required init?(coder: NSCoder) {
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(coder: coder)
		setupObservers()
		setupFileStream()
	}

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 22)
		#endif
		self.init(frame: frame)
	}

	deinit {
		removeObservers()
	}

	private func setupObservers() {
		/* Start observe */
		let tpref = CNPreference.shared.terminalPreference
		tpref.addObserver(observer: self, forKey: tpref.WidthItem)
		tpref.addObserver(observer: self, forKey: tpref.HeightItem)
		tpref.addObserver(observer: self, forKey: tpref.ForegroundTextColorItem)
		tpref.addObserver(observer: self, forKey: tpref.BackgroundTextColorItem)
		tpref.addObserver(observer: self, forKey: tpref.FontItem)

		let spref = CNPreference.shared.systemPreference
		spref.addObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
	}

	private func setupFileStream() {
		mOutputPipe.fileHandleForReading.readabilityHandler = {
			(_ hdl: FileHandle) -> Void in
			let data = hdl.availableData
			if let str = String.stringFromData(data: data) {
				self.execute(string: str)
			}
		}
		mErrorPipe.fileHandleForReading.readabilityHandler = {
			(_ hdl: FileHandle) -> Void in
			let data = hdl.availableData
			if let str = String.stringFromData(data: data) {
				self.execute(string: str)
			}
		}
	}

	private func removeObservers() {
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil

		/* Stop to observe */
		let pref = CNPreference.shared.terminalPreference
		pref.removeObserver(observer: self, forKey: pref.WidthItem)
		pref.removeObserver(observer: self, forKey: pref.HeightItem)
		pref.removeObserver(observer: self, forKey: pref.ForegroundTextColorItem)
		pref.removeObserver(observer: self, forKey: pref.BackgroundTextColorItem)
		pref.removeObserver(observer: self, forKey: pref.FontItem)

		let syspref = CNPreference.shared.systemPreference
		syspref.removeObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)
	}

	public var outputFileHandle: FileHandle {
		get { return mOutputPipe.fileHandleForWriting }
	}

	public var errorFileHandle: FileHandle {
		get { return mErrorPipe.fileHandleForWriting }
	}

	public func execute(string str: String) {
		switch CNEscapeCode.decode(string: str) {
		case .ok(let codes):
			super.execute(escapeCodes: codes)
		case .error(let err):
			CNLog(logLevel: .error, message: "Failed to decode escape code: \(err.description())")
		@unknown default:
			CNLog(logLevel: .error, message: "Failed to decode escape code: <unknown>")
		}
	}
}

/*
open class KCConsoleView : KCCoreView
{
	private var mConsole:	CNFileConsole?	= nil
	
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

	public var foregroundTextColor: CNColor {
		get		{ return coreView.foregroundTextColor }
	}

	public var backgroundTextColor: CNColor {
		get		{ return coreView.backgroundTextColor }
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCConsoleView.self, nibName: "KCTerminalViewCore") as? KCTerminalViewCore  {
			setCoreView(view: newview)
			newview.setup(mode: .log, frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			CNLog(logLevel: .error, message: "Failed to load resource")
			return
		}
	}
	
	public var font: CNFont {
		get		{ return coreView.font	}
	}

	public func clear(){
		let code = CNEscapeCode.eraceEntireBuffer.encode()
		if let cons = mConsole {
			cons.print(string: code)
		}
	}

	public var width: Int {
		get { return coreView.width }
	}

	public var height: Int {
		get { return coreView.height }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(consoleView: self)
	}

	private var coreView: KCTerminalViewCore {
		get { return getCoreView() }
	}
}
*/


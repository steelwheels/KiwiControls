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

open class KCTerminalView : KCTextView
{
	private var mInputPipe:			Pipe
	private var mOutputPipe:		Pipe
	private var mErrorPipe:			Pipe

	#if os(OSX)
	public override init(frame : NSRect){
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(frame: frame)
		setup()
	}
	#else
	public override init(frame: CGRect){
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(frame: frame)
		setup()
	}
	#endif

	public required init?(coder: NSCoder) {
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		super.init(coder: coder)
		setup()
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

	private func setup() {
		/* Start observe */
		let tpref = CNPreference.shared.terminalPreference
		tpref.addObserver(observer: self, forKey: tpref.WidthItem)
		tpref.addObserver(observer: self, forKey: tpref.HeightItem)
		tpref.addObserver(observer: self, forKey: tpref.ForegroundTextColorItem)
		tpref.addObserver(observer: self, forKey: tpref.BackgroundTextColorItem)
		tpref.addObserver(observer: self, forKey: tpref.FontItem)

		let spref = CNPreference.shared.systemPreference
		spref.addObserver(observer: self, forKey: CNSystemPreference.InterfaceStyleItem)

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

		self.setAckCallback(callback: {
			(_ codes: Array<CNEscapeCode>) -> Void in
			var encstr: String = ""
			for code in codes {
				encstr += code.encode()
			}
			self.mInputPipe.fileHandleForWriting.write(string: encstr)
		})
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

	public var inputFileHandle: FileHandle {
		get { return mInputPipe.fileHandleForReading }
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
		super.setFrameSize(newSize)
	}

	open override func setBoundsSize(_ newSize: NSSize) {
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
*/


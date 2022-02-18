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
	private var mOutputPipe:	Pipe
	private var mErrorPipe:		Pipe
	private var mOutputFile:	CNFile
	private var mErrorFile:		CNFile

	private var mTerminalListners:	Array<CNObserverDictionary.ListnerHolder>
	private var mSystemListners:	Array<CNObserverDictionary.ListnerHolder>

	public var outputFile:  	CNFile { get { return mOutputFile }}
	public var errorFile:		CNFile { get { return mErrorFile  }}

	#if os(OSX)
	public override init(frame : NSRect){
		mOutputPipe		= Pipe()
		mErrorPipe		= Pipe()
		mOutputFile		= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mErrorFile		= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mTerminalListners	= []
		mSystemListners		= []
		super.init(frame: frame)
		setupObservers()
		setupFileStream()
	}
	#else
	public override init(frame: CGRect){
		mOutputPipe		= Pipe()
		mErrorPipe		= Pipe()
		mOutputFile		= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mErrorFile		= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mTerminalListners	= []
		mSystemListners		= []
		super.init(frame: frame)
		setupObservers()
		setupFileStream()
	}
	#endif

	public required init?(coder: NSCoder) {
		mOutputPipe		= Pipe()
		mErrorPipe		= Pipe()
		mOutputFile		= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mErrorFile		= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mTerminalListners	= []
		mSystemListners		= []
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
		mOutputPipe.fileHandleForReading.readabilityHandler = nil
		mErrorPipe.fileHandleForReading.readabilityHandler  = nil

		let tpref = CNPreference.shared.terminalPreference
		for holder in mTerminalListners {
			tpref.removeObserver(listnerHolder: holder)
		}
		let spref = CNPreference.shared.systemPreference
		for holder in mSystemListners {
			spref.removeObserver(listnerHolder: holder)
		}
	}

	private func setupObservers() {
		/* Set observer */
		let tpref = CNPreference.shared.terminalPreference
		mTerminalListners.append(
			tpref.addObserver(forKey: tpref.WidthItem, listnerFunction: {
				(_ param: Any) -> Void in
				CNLog(logLevel: .error, message: "Update width: \(tpref.width)", atFunction: #function, inFile: #file)
			})
		)
		mTerminalListners.append(
			tpref.addObserver(forKey: tpref.HeightItem, listnerFunction: {
				(_ param: Any) -> Void in
				CNLog(logLevel: .error, message: "Update height: \(tpref.height)", atFunction: #function, inFile: #file)
			})
		)
		mTerminalListners.append(
			tpref.addObserver(forKey: tpref.ForegroundTextColorItem, listnerFunction: {
				(_ param: Any) -> Void in
				CNLog(logLevel: .detail, message: "Update foregroundcolor: \(tpref.foregroundTextColor)", atFunction: #function, inFile: #file)
			})
		)
		mTerminalListners.append(
			tpref.addObserver(forKey: tpref.BackgroundTextColorItem, listnerFunction: {
				(_ param: Any) -> Void in
				CNLog(logLevel: .detail, message: "Update backgroundcolor: \(tpref.backgroundTextColor)", atFunction: #function, inFile: #file)
			})
		)
		mTerminalListners.append(
			tpref.addObserver(forKey: tpref.FontItem, listnerFunction: {
				(_ param: Any) -> Void in
				CNLog(logLevel: .detail, message: "Update font: \(tpref.font)", atFunction: #function, inFile: #file)
			})
		)

		let spref = CNPreference.shared.systemPreference
		mSystemListners.append(
			spref.addObserver(forKey: CNSystemPreference.InterfaceStyleItem, listnerFunction: {
				(_ param: Any) -> Void in
				CNLog(logLevel: .detail, message: "Update interface: \(spref.interfaceStyle)", atFunction: #function, inFile: #file)
			})
		)
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

	public func execute(string str: String) {
		switch CNEscapeCode.decode(string: str) {
		case .ok(let codes):
			super.execute(escapeCodes: codes)
		case .error(let err):
			CNLog(logLevel: .error, message: "Failed to decode escape code: \(err.toString())")
		@unknown default:
			CNLog(logLevel: .error, message: "Failed to decode escape code: <unknown>")
		}
	}
}



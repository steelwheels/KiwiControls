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
	private var mInputPipe:		Pipe
	private var mOutputPipe:	Pipe
	private var mErrorPipe:		Pipe

	private var mInputFile:		CNFile
	private var mOutputFile:	CNFile
	private var mErrorFile:		CNFile

	public var inputFile:  CNFile { get { return mInputFile  }}
	public var outputFile: CNFile { get { return mOutputFile }}
	public var errorFile:  CNFile { get { return mErrorFile  }}

	#if os(OSX)
	public override init(frame : NSRect){
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mInputFile	= CNFile(access: .reader, fileHandle: mInputPipe.fileHandleForReading)
		mOutputFile	= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mErrorFile 	= CNFile(access: .writer, fileHandle: mErrorPipe.fileHandleForWriting)

		super.init(frame: frame)
		setup()
	}
	#else
	public override init(frame: CGRect){
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mInputFile	= CNFile(access: .reader, fileHandle: mInputPipe.fileHandleForReading)
		mOutputFile	= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mErrorFile 	= CNFile(access: .writer, fileHandle: mErrorPipe.fileHandleForWriting)

		super.init(frame: frame)
		setup()
	}
	#endif

	public required init?(coder: NSCoder) {
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mInputFile	= CNFile(access: .reader, fileHandle: mInputPipe.fileHandleForReading)
		mOutputFile	= CNFile(access: .writer, fileHandle: mOutputPipe.fileHandleForWriting)
		mErrorFile 	= CNFile(access: .writer, fileHandle: mErrorPipe.fileHandleForWriting)

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


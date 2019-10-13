/**
 * @file	KCLogManager.swift
 * @brief	Define KCLogManager class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLogManager
{
	private static var mSharedManager: KCLogManager? = nil

	public static var shared: KCLogManager {
		get {
			if let manager = mSharedManager {
				return manager
			} else {
				let newmanager = KCLogManager()
				mSharedManager = newmanager
				return newmanager
			}
		}
	}

	#if os(OSX)
		private var		mWindowController: KCLogWindowController
	#else
		private weak var	mViewController: KCLogViewController?
	#endif
	private var mEnable: 		Bool
	private var mInputPipe:		Pipe
	private var mOutputPipe:	Pipe
	private var mErrorPipe:		Pipe
	private var mConsole: 		CNFileConsole

	public var console: CNFileConsole { get { return mConsole }}

	private init(){
		#if os(OSX)
			mWindowController = KCLogWindowController.allocateController()
		#else
			mViewController   = nil
		#endif
		mEnable		= true
		mInputPipe	= Pipe()
		mOutputPipe	= Pipe()
		mErrorPipe	= Pipe()
		mConsole	= CNFileConsole(input: mInputPipe.fileHandleForReading,
						output: mOutputPipe.fileHandleForWriting,
						error: mErrorPipe.fileHandleForWriting)

		/* Close input */
		mInputPipe.fileHandleForWriting.closeFile()

		/* Connect output */
		mOutputPipe.fileHandleForReading.readabilityHandler = {
			[weak self] (_ handle: FileHandle) -> Void in
			if let myself = self {
				if let str = String(data: handle.availableData, encoding: .utf8) {
					CNExecuteInMainThread(doSync: false, execute: {
						() -> Void in
						myself.print(string: str)
					})
				} else {
					NSLog("Non string data")
				}
			}
		}
		/* Connect error */
		mErrorPipe.fileHandleForReading.readabilityHandler = {
			[weak self] (_ handle: FileHandle) -> Void in
			if let myself = self {
				if let str = String(data: handle.availableData, encoding: .utf8) {
					CNExecuteInMainThread(doSync: false, execute: {
						() -> Void in
						myself.error(string: str)
					})
				} else {
					NSLog("Non string data")
				}
			}
		}
	}

	#if os(iOS)
	public var viewController: KCLogViewController? {
		get { return mViewController }
		set(newview) { mViewController = newview }
	}
	#endif

	private func show() {
		#if os(OSX)
			mWindowController.show()
		#endif
	}

	private func hide() {
		#if os(OSX)
			mWindowController.hide()
		#endif
	}

	private func print(string str: String){
		if mEnable {
			#if os(OSX)
				//NSLog("LogCons: print \(str)\n")
				mWindowController.show()
				return mWindowController.print(string: str)
			#else
				if let cons = mViewController?.consoleConnection {
					cons.print(string: str)
				} else {
					Swift.print(str, terminator: "")
				}
			#endif
		}
	}

	private func error(string str: String){
		if mEnable {
			#if os(OSX)
				//NSLog("LogCons: error \(str)\n")
				mWindowController.show()
				return mWindowController.error(string: str)
			#else
				if let cons = mViewController?.consoleConnection {
					cons.error(string: str)
				} else {
					Swift.print(str, terminator: "")
				}
			#endif
		}
	}
}


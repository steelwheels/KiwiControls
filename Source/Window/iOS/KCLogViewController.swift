/**
 * @file	KCLogViewController.swift
 * @brief	Define KCLogViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLogViewController
{
	public static let shared = KCLogViewController()

	private var mConsoleView: 	KCConsoleView?    = nil
	private var mBufferConsole:	CNBufferedConsole = CNBufferedConsole()

	private init(){
	}

	public var inputConsole: CNConsole {
		get { return mBufferConsole }
	}

	public func setLogViewConsole(console cons: CNConsole){
		mBufferConsole.receiverConsole = cons
	}
}

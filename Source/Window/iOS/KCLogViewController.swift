/**
 * @file	KCLogViewController.swift
 * @brief	Define KCLogViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class KCLogViewController
{
	static let shared = KCLogViewController()

	private var mConsoleView: KCConsoleView? = nil
	private var mConsole:	  KCConsole?     = nil

	public var consoleView: KCConsoleView? {
		set(view) {
			mConsoleView = view
			if let v = view {
				mConsole = KCConsole(ownerView: v)
			} else {
				mConsole = nil
			}
		}
		get {
			return mConsoleView
		}
	}

	public var console: KCConsole? {
		get { return mConsole }
	}
	
	private init(){

	}
}

/**
 * @file	KCLogWindowController.swift
 * @brief	Define KCLogWindowController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)

import CoconutData
import Foundation

public class KCLogConsole: CNConsole
{
	public var 		enable: Bool = true
	private weak var	mWindowController: KCLogWindowController? = nil

	private var windowController: KCLogWindowController {
		get {
			if let cont = mWindowController {
				return cont
			} else {
				let newcont = KCLogWindowController.allocateController()
				mWindowController = newcont
				return newcont
			}
		}
	}

	public func show() {
		let cont = windowController
		cont.showWindow(cont)
	}

	open override func print(string str: String){
		if enable {
			return windowController.print(string: str)
		}
	}

	open override func error(string str: String){
		if enable {
			return windowController.error(string: str)
		}
	}

	open override func scan() -> String? {
		if enable {
			return windowController.scan()
		} else {
			return nil
		}
	}
}

fileprivate class KCLogWindowController: NSWindowController
{
	private var mViewController:	KCLogViewController
	private var mConsoleView:	KCConsoleView
	private var mConsole:		KCConsole

	public class func allocateController() -> KCLogWindowController {
		let viewcont	      = KCLogViewController()
		let (window, console) = KCLogWindowController.loadWindow(delegate: viewcont)
		return KCLogWindowController(viewController: viewcont, window: window, consoleView: console)
	}

	public init(viewController viewcont: KCLogViewController, window win: KCWindow, consoleView consview: KCConsoleView){
		mViewController		= viewcont
		mConsoleView		= consview
		mConsole		= KCConsole(ownerView: consview)
		super.init(window: win)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func print(string str: String){
		mConsole.print(string: str)
	}

	public func error(string str: String){
		mConsole.error(string: str)
	}

	public func scan() -> String? {
		return mConsole.scan()
	}

	private class func loadWindow(delegate dlg: KCViewControllerDelegate) -> (KCWindow, KCConsoleView) {
		if let newwin = KCWindow.loadWindow(delegate: dlg) {
			newwin.title = "Log"
			let box = KCStackView(frame: newwin.frame)
			newwin.setRootView(view: box)
			let button  = KCButton()
			let console = KCConsoleView()
			let children: Array<KCView> = [console, button]
			box.addArrangedSubViews(subViews: children)
			return (newwin, console)
		} else {
			fatalError("Failed to allocate window")
		}
	}
}

fileprivate class KCLogViewController: KCViewControllerDelegate
{
}

/*

public class KCLogWindowController: KCViewControllerDelegate
{
	private var mLogWindow: 	KCWindow?	= nil
	private var mConsoleView:	KCConsoleView?	= nil
	private var mConsole:		KCConsole?	= nil

	public func print(string str: String) {
		let (_, _, console) = openWindow()
		console.print(string: str)
	}

	public func error(string str: String) {
		let (_, _, console) = openWindow()
		console.error(string: str)
	}

	public func scan() -> String? {
		let (_, _, console) = openWindow()
		return console.scan()
	}

	private func openWindow() -> (KCWindow, KCConsoleView, KCConsole) {
		if let win = mLogWindow, let cview = mConsoleView, let cons = mConsole {
			return (win, cview, cons)
		} else {
			let (newwin, newcview) = loadWindow()
			mLogWindow   = newwin
			mConsoleView = newcview
			let newcons  = KCConsole(ownerView: newcview)
			mConsole     = newcons
			return (newwin, newcview, newcons)
		}
	}

	private func loadWindow() -> (KCWindow, KCConsoleView) {
		if let newwin = KCWindow.loadWindow(delegate: self) {
			let box = KCStackView(frame: newwin.frame)
			newwin.setRootView(view: box)
			let button  = KCButton()
			let console = KCConsoleView()
			let children: Array<KCView> = [console, button]
			box.addArrangedSubViews(subViews: children)
			return (newwin, console)
		} else {
			fatalError("Failed to allocate window")
		}
	}
}
*/

#endif // os(OSX)

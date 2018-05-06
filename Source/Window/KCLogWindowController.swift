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
		windowController.show()
	}

	public func hide() {
		windowController.hide()
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
	private var mButton:		KCButton

	public class func allocateController() -> KCLogWindowController {
		let viewcont	              = KCLogViewController()
		let (window, console, button) = KCLogWindowController.loadWindow(delegate: viewcont)
		return KCLogWindowController(viewController: viewcont, window: window, consoleView: console, button: button)
	}

	public init(viewController viewcont: KCLogViewController, window win: KCWindow, consoleView consview: KCConsoleView, button btn: KCButton){
		mViewController		= viewcont
		mConsoleView		= consview
		mConsole		= KCConsole(ownerView: consview)
		mButton			= btn
		super.init(window: win)

		btn.buttonPressedCallback = {
			() -> Void in
			self.hide()
		}
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

	public func show() {
		self.window?.orderFront(self.window)
	}

	public func hide() {
		self.window?.orderOut(self.window)
	}

	private class func loadWindow(delegate dlg: KCViewControllerDelegate) -> (KCWindow, KCConsoleView, KCButton) {
		if let newwin = KCWindow.loadWindow(delegate: dlg) {
			newwin.title = "Log"
			let box = KCStackView(frame: newwin.frame)
			newwin.setRootView(view: box)
			let button  = KCButton()
			button.title = "Close"
			let console = KCConsoleView()
			let children: Array<KCView> = [console, button]
			box.addArrangedSubViews(subViews: children)
			return (newwin, console, button)
		} else {
			fatalError("Failed to allocate window")
		}
	}
}

fileprivate class KCLogViewController: KCViewControllerDelegate
{
}

#endif // os(OSX)

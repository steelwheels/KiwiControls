/**
 * @file	KCLogWindowController.swift
 * @brief	Define KCLogWindowController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCLogWindowController: NSWindowController
{
	private var mConsoleView:	KCConsoleView
	private var mConsole:		KCConsole
	private var mButton:		KCButton

	public class func allocateController() -> KCLogWindowController {
		let (window, console, button) = KCLogWindowController.loadWindow()
		return KCLogWindowController(window: window, consoleView: console, button: button)
	}

	public required init(window win: NSWindow, consoleView consview: KCConsoleView, button btn: KCButton){
		mConsoleView		= consview
		mConsole		= KCConsole(ownerView: consview)
		mButton			= btn
		super.init(window: win)
		/* Set console color */
		mConsoleView.color = KCTextColor(normal:     KCColorTable.green,
						 error:      KCColorTable.red,
						 background: KCColorTable.black)
		btn.buttonPressedCallback = {
			[weak self] () -> Void in
			if let myself = self {
				myself.hide()
			}
		}
	}

	public required init?(coder: NSCoder) {
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

	private class func loadWindow() -> (NSWindow, KCConsoleView, KCButton) {
		if let newwin = NSWindow.loadWindow() {
			newwin.title = "Log"
			let box = KCStackView(frame: newwin.frame)
			newwin.setRootView(view: box)
			let button  = KCButton()
			button.title = "Close"
			let cons = KCConsoleView()
			let children: Array<KCView> = [cons, button]
			box.addArrangedSubViews(subViews: children)
			return (newwin, cons, button)
		} else {
			fatalError("Failed to allocate window")
		}
	}
}



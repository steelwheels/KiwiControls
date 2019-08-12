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

	public class func allocateController() -> KCLogWindowController {
		let (window, console, clearbtn, closebtn) = KCLogWindowController.loadWindow()
		return KCLogWindowController(window: window, consoleView: console, clearButton: clearbtn, closeButton: closebtn)
	}

	public required init(window win: NSWindow, consoleView consview: KCConsoleView, clearButton clearbtn: KCButton, closeButton closebtn: KCButton){
		mConsoleView		= consview
		mConsole		= KCConsole(ownerView: consview)
		super.init(window: win)
		/* Set console color */
		mConsoleView.color = KCTextColor(normal:     KCColorTable.green,
						 error:      KCColorTable.red,
						 background: KCColorTable.black)
		clearbtn.buttonPressedCallback = {
			consview.clear()
		}
		closebtn.buttonPressedCallback = {
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

	private class func loadWindow() -> (NSWindow, KCConsoleView, KCButton, KCButton) {
		if let newwin = NSWindow.loadWindow() {
			/* Setup window */
			newwin.title = "Log"

			/* Console view */
			let cons = KCConsoleView()

			/* Clear button */
			let clearbtn = KCButton()
			clearbtn.title = "Clear"
			/* Close button */
			let closebtn = KCButton()
			closebtn.title = "Close"
			/* Buttons box */
			let btnwidth  = clearbtn.frame.size.width + closebtn.frame.size.width
			let btnheight = max(clearbtn.frame.size.height, closebtn.frame.size.height)
			let btnframe  = KCRect(origin: KCPoint.zero, size: KCSize(width: btnwidth, height: btnheight))
			let btnbox    = KCStackView(frame: btnframe)
			btnbox.axis = .horizontal
			btnbox.distribution = .fillEqually
			btnbox.addArrangedSubViews(subViews: [clearbtn, closebtn])
			/* Log box */
			let logwidth  = max(cons.frame.width, btnwidth)
			let logheight = cons.frame.height + btnheight
			let logframe  = KCRect(origin: KCPoint.zero, size: KCSize(width: logwidth, height: logheight))
			let logbox    = KCStackView(frame: logframe)
			logbox.axis = .vertical
			logbox.addArrangedSubViews(subViews: [cons, btnbox])
			/* Add contents to window */
			newwin.setRootView(view: logbox)
			newwin.resize(size: logframe.size)
			return (newwin, cons, clearbtn, closebtn)
		} else {
			fatalError("Failed to allocate window")
		}
	}
}



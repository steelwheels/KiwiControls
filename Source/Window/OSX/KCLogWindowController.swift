/**
 * @file	KCLogWindowController.swift
 * @brief	Define KCLogWindowController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

public class KCLogWindowController: NSWindowController
{
	private var mConsoleView:	KCConsoleView

	public class func allocateController() -> KCLogWindowController {
		let (window, console, clearbtn) = KCLogWindowController.loadWindow()
		return KCLogWindowController(window: window, consoleView: console, clearButton: clearbtn)
	}

	public var console: CNConsole { get { return mConsoleView.consoleConnection }}

	public required init(window win: NSWindow, consoleView consview: KCConsoleView, clearButton clearbtn: KCButton){
		mConsoleView		= consview
		super.init(window: win)
		clearbtn.buttonPressedCallback = {
			consview.clear()
		}
	}

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var isVisible: Bool {
		get {
			if let win = self.window {
				return win.isVisible
			} else {
				return false
			}
		}
	}

	public func show() {
		self.window?.orderFront(self.window)
	}

	public func hide() {
		self.window?.orderOut(self.window)
	}

	private class func loadWindow() -> (NSWindow, KCConsoleView, KCButton) {
		if let newwin = NSWindow.loadWindow() {
			/* Setup window */
			newwin.title = "Log"

			/* Console view */
			let cons = KCConsoleView()

			/* Clear button */
			let clearbtn = KCButton()
			clearbtn.title = "Clear"
			/* Buttons box */
			let btnframe  = KCRect(origin: KCPoint.zero, size: clearbtn.frame.size)
			let btnbox    = KCStackView(frame: btnframe)
			btnbox.axis = .horizontal
			btnbox.distribution = .fillEqually
			btnbox.addArrangedSubView(subView: clearbtn)
			/* Log box */
			let logwidth  = max(cons.frame.width, clearbtn.frame.width)
			let logheight = cons.frame.height + clearbtn.frame.height
			let logframe  = KCRect(origin: KCPoint.zero, size: KCSize(width: logwidth, height: logheight))
			let logbox    = KCStackView(frame: logframe)
			logbox.axis = .vertical
			logbox.addArrangedSubViews(subViews: [cons, btnbox])
			/* Add contents to window */
			newwin.setRootView(view: logbox)
			newwin.resize(size: logframe.size)
			return (newwin, cons, clearbtn)
		} else {
			fatalError("Failed to allocate window")
		}
	}
}



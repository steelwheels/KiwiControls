//
//  ViewController.swift
//  UTTable
//
//  Created by Tomoo Hamada on 2021/05/14.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCViewController, KCViewControlEventReceiver
{
	@IBOutlet weak var mTableView: KCTableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		/* Start logging */
		NSLog("Start logging ... begin")
		let _ = KCLogManager.shared // init
		CNPreference.shared.systemPreference.logLevel = .debug
		NSLog("Start logging ... end")

		/* Set editable */
		mTableView.isEditable = true
		mTableView.hasHeader  = true

		CNLog(logLevel: .debug, message: "setup value table", atFunction: #function, inFile: #file)
		let table = CNNativeValueTable()
		for y in 0..<2 {
			for x in 0..<3 {
				let str = "\(x)/\(y)"
				table.setValue(columnIndex: .number(x), row: y, value: .stringValue(str))
			}
		}

		CNLog(logLevel: .debug, message: "reload data", atFunction: #function, inFile: #file)
		mTableView.reload(table: table)

		mTableView.hasGrid = true
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	public override func viewDidLayout() {
		/* Init window */
		if let win = self.view.window {
			NSLog("Initialize window attributes")
			initWindowAttributes(window: win)
		} else {
			NSLog("[Error] No window")
		}
	}

	public override func viewDidAppear() {
		if let window = self.view.window {
			/* decide 1st responder */
			/*
			if let resp = mTableView.firstResponderView {
				window.makeFirstResponder(resp)
			}
*/
			mTableView.dump()
		} else {
			CNLog(logLevel: .error, message: "No window at \(#function)")
		}
	}

	public func notifyControlEvent(viewControlEvent event: KCViewControlEvent) {
		switch event {
		case .none:
			CNLog(logLevel: .detail, message: "Control event: none", atFunction: #function, inFile: #file)
		case .updateSize:
			CNLog(logLevel: .detail, message: "Update window size", atFunction: #function, inFile: #file)
		case .switchFirstResponder(let newview):
			NSLog("switchFirstResponder (0)")
			if let window = self.view.window {
				NSLog("switchFirstResponder (1)")
				if window.makeFirstResponder(newview) {
					NSLog("makeFirstResponder -> Succeess")
				} else {
					NSLog("makeFirstResponder -> Fail")
				}
			} else {
				CNLog(logLevel: .error, message: "Failed to switch first responder", atFunction: #function, inFile: #file)
			}
		}
	}
}


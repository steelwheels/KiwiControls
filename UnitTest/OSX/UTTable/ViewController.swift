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
		//mTableView.isEditable = true
		mTableView.isEnable = true
		mTableView.hasHeader  = true

		CNLog(logLevel: .debug, message: "setup value table", atFunction: #function, inFile: #file)
		let table = CNNativeValueTable()
		for y in 0..<2 {
			let record = CNValueRecord()
			for x in 0..<3 {
				let str = "\(x)/\(y)"
				if record.setValue(value: .stringValue(str), forField: "\(x)") {
					NSLog("setValue(\(str), \(x)) ... OK")
				} else {
					NSLog("setValue(\(str), \(x)) ... Failed")
				}
			}
			table.append(record: record)
		}

		CNLog(logLevel: .debug, message: "reload data", atFunction: #function, inFile: #file)
		mTableView.load(table: table)

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
		mTableView.stateListner = {
			(_ state: KCTableView.DataState) -> Void in
			NSLog("change state: \(state)")
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


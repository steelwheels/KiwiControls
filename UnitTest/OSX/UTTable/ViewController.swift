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
		let table = CNValueTable()
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
		let viewtbl = KCTableBridge(table: table)
		mTableView.load(table: viewtbl)

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
		case .updateSize(let targview):
			CNLog(logLevel: .detail, message: "Update window size: \(targview.description)", atFunction: #function, inFile: #file)
		case .switchFirstResponder(let newview):
			if let window = self.view.window {
				if !window.makeFirstResponder(newview) {
					CNLog(logLevel: .error, message: "makeFirstResponder -> Fail", atFunction: #function, inFile: #file)
				}
			} else {
				CNLog(logLevel: .error, message: "Failed to switch first responder", atFunction: #function, inFile: #file)
			}
		}
	}
}


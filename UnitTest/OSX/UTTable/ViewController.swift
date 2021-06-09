//
//  ViewController.swift
//  UTTable
//
//  Created by Tomoo Hamada on 2021/05/14.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController
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

		CNLog(logLevel: .debug, message: "setup value table", atFunction: #function, inFile: #file)
		let table = mTableView.valueTable
		for y in 0..<2 {
			for x in 0..<3 {
				let str = "\(x)/\(y)"
				table.setValue(columnIndex: .number(x), row: y, value: .stringValue(str))
			}
		}

		CNLog(logLevel: .debug, message: "reload data", atFunction: #function, inFile: #file)
		mTableView.reloadTable()

		mTableView.hasGrid = true
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


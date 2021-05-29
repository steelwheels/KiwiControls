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

		NSLog("UTTable: setup value table")
		let table = mTableView.valueTable
		for y in 0..<2 {
			for x in 0..<3 {
				let str = "\(x)/\(y)"
				table.setValue(column: x, row: y, value: .stringValue(str))
			}
		}

		NSLog("UTTable: reload data")
		mTableView.reloadTable()

		mTableView.hasGrid = true
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


//
//  ViewController.swift
//  UTTextFieldCell
//
//  Created by Tomoo Hamada on 2016/07/26.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCControls

class ViewController: NSViewController
{
	@IBOutlet weak var mTableView: NSTableView!

	private var mTableDelegate	= UTTableDelegate()
	private var mTableDataSource	= UTTableDataSource()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mTableView.delegate = mTableDelegate
		mTableView.dataSource = mTableDataSource
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


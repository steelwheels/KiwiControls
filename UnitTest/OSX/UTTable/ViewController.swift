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
		guard let resurl  = CNFilePath.URLForResourceDirectory(directoryName: "Data", subdirectory: nil, forClass: ViewController.self) else {
			NSLog("Failed to get URL")
			return
		}

		let storage = CNValueStorage(packageDirectory: resurl, filePath: "storage.json", parentStorage: nil)
		switch storage.load() {
		case .ok(_):
			break
		case .error(let err):
			NSLog("[Error] \(err.toString())")
			return
		@unknown default:
			NSLog("[Error] Unknown error")
			return
		}

		let tblpath = CNValuePath(elements: [.member("data")])
		let table   = CNValueTable(path: tblpath, valueStorage: storage)
		let recnum  = table.recordCount
		NSLog("record count: \(recnum)")

		NSLog("Set visible fields")
		mTableView.activeFieldNames = [
			KCTableView.ActiveFieldName(field: "c0", title: "col 0"),
			KCTableView.ActiveFieldName(field: "c1", title: "col 1"),
			KCTableView.ActiveFieldName(field: "c2", title: "col 2")
		]

		CNLog(logLevel: .debug, message: "reload data", atFunction: #function, inFile: #file)
		mTableView.store(table: table)

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


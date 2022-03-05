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
	@IBOutlet weak var mAddButton: KCButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTableView()
		self.setupAddButton()
	}

	private func setupTableView() {
		/* Start logging */
		NSLog("Start logging ... begin")
		let _ = KCLogWindowManager.shared // init
		CNPreference.shared.systemPreference.logLevel = .debug
		NSLog("Start logging ... end")

		/* Set editable */
		//mTableView.isEditable = true
		mTableView.isEnable = true
		mTableView.hasHeader  = true

		CNLog(logLevel: .debug, message: "setup value table", atFunction: #function, inFile: #file)

		guard let srcfile = CNFilePath.URLForResourceFile(fileName: "storage", fileExtension: "json", subdirectory: "Data", forClass: ViewController.self) else {
			NSLog("Failed to get URL of storage.json")
			return
		}
		let srcdir = srcfile.deletingLastPathComponent()
		let cachefile = CNFilePath.URLForApplicationSupportFile(fileName: "storage", fileExtension: "json", subdirectory: "Data")
		let cachedir  = cachefile.deletingLastPathComponent()

		if !FileManager.default.copyFileIfItIsNotExist(sourceFile: srcfile, destinationFile: cachefile) {
			NSLog("Failed to copy file")
			return
		}

		let storage = CNValueStorage(sourceDirectory: srcdir, cacheDirectory: cachedir, filePath: "storage.json")
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
		mTableView.dataTable = table // reload

		mTableView.hasGrid = true
	}

	private func setupAddButton() {
		mAddButton.buttonPressedCallback = {
			() -> Void in
			NSLog("Button pressed callback")
			guard let table = self.mTableView.dataTable as? CNValueTable else {
				NSLog("No data table")
				return
			}

			let newrec = CNValueRecord()
			if !newrec.setValue(value: .numberValue(NSNumber(floatLiteral: 10.1)), forField: "c0") { NSLog("Failed to set c0") }
			if !newrec.setValue(value: .numberValue(NSNumber(floatLiteral: 20.2)), forField: "c1") { NSLog("Failed to set c1") }
			if !newrec.setValue(value: .numberValue(NSNumber(floatLiteral: 30.3)), forField: "c2") { NSLog("Failed to set c2") }

			//let txt = table.toText().toStrings().joined(separator: "\n")
			//NSLog("new table = \(txt)")
			table.append(record: newrec)
		}
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


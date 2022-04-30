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
	@IBOutlet weak var mSaveButton: KCButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTableView()
		self.setupUpdateButton()
		self.setupSaveButton()
	}

	private func setupTableView() {
		/* Start logging */
		NSLog("Start logging ... begin")
		let _ = KCLogWindowManager.shared // init
		CNPreference.shared.systemPreference.logLevel = .debug
		NSLog("Start logging ... end")

		/* Set editable */
		mTableView.hasGrid   = true
		mTableView.isEnable  = true
		mTableView.hasHeader = true

/*
		mTableView.isSelectable = true
*/
		let table   = loadTable(name: "storage")
		let recnum  = table.recordCount
		NSLog("record count: \(recnum)")

		NSLog("Set visible fields")
		mTableView.fieldNames = [
			KCTableView.FieldName(field: "c0", title: "col 0"),
			KCTableView.FieldName(field: "c1", title: "col 1"),
			KCTableView.FieldName(field: "c2", title: "col 2")
		]
		CNLog(logLevel: .debug, message: "reload data", atFunction: #function, inFile: #file)
		mTableView.dataTable = table
		mTableView.filterFunction = {
			(_ rec: CNRecord) -> Bool in
			for field in rec.fieldNames {
				var fval:  String = "?"
				if let fld = rec.value(ofField: field) {
					fval = fld.toText().toStrings().joined(separator: "\n")
				}
				NSLog("recordMapping: field=\(field), value=\(fval)")
			}
			return true
		}
		mTableView.reload()
	}

	private func setupUpdateButton() {
		mAddButton.value = .text("Update")
		mAddButton.buttonPressedCallback = {
			() -> Void in
			NSLog("Button pressed callback")

			let table   = self.loadTable(name: "storage2")
			let recnum  = table.recordCount
			NSLog("record count: \(recnum)")

			self.mTableView.hasGrid = true
			CNLog(logLevel: .debug, message: "reload data", atFunction: #function, inFile: #file)

			self.mTableView.fieldNames = [
				KCTableView.FieldName(field: "c0", title: "col 0"),
				KCTableView.FieldName(field: "c1", title: "col 1"),
				KCTableView.FieldName(field: "c2", title: "col 2")
			]
			self.mTableView.dataTable = table
			self.mTableView.reload()
		}
	}

	private func setupSaveButton() {
		mSaveButton.value = .text("Save")
		mSaveButton.buttonPressedCallback = {
			if self.mTableView.dataTable.save() {
				NSLog("save ... ok")
			} else {
				NSLog("save ... error")
			}
		}
	}

	private func loadTable(name nm: String) -> CNMappingTable {
		CNLog(logLevel: .debug, message: "setup value table", atFunction: #function, inFile: #file)

		guard let srcfile = CNFilePath.URLForResourceFile(fileName: nm, fileExtension: "json", subdirectory: "Data", forClass: ViewController.self) else {
			NSLog("Failed to get URL of storage.json")
			fatalError("Terminated")
		}
		let srcdir = srcfile.deletingLastPathComponent()
		let cachefile = CNFilePath.URLForApplicationSupportFile(fileName: nm, fileExtension: "json", subdirectory: "Data")
		let cachedir  = cachefile.deletingLastPathComponent()

		let storage = CNValueStorage(sourceDirectory: srcdir, cacheDirectory: cachedir, filePath: nm + ".json")
		switch storage.load() {
		case .ok(_):
			break
		case .error(let err):
			NSLog("[Error] \(err.toString())")
			fatalError("Terminated")
		@unknown default:
			NSLog("[Error] Unknown error")
			fatalError("Terminated")
		}

		let tblpath = CNValuePath(identifier: nil, elements: [.member("data")])
		let valtbl  = CNValueTable(path: tblpath, valueStorage: storage)
		return CNMappingTable(sourceTable: valtbl)
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


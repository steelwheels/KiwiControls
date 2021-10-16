/**
 * @file SingleView0Controller.swift
 * @brief Define SingleView0Controller. class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import Cocoa
import Foundation

public class SingleViewController: KCSingleViewController
{
	public override init(parentViewController parent: KCMultiViewController){
		super.init(parentViewController: parent)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public override func loadContext() -> KCView? {
		NSLog("load context")
		let result = KCCollectionView()
		let newcol = allocateValue()
		result.store(dataInterface: newcol)
		return result
	}

	public override func viewDidLoad() {
		CNLog(logLevel: .detail, message: "viewDidLoad")
		super.viewDidLoad()
	}

	#if os(OSX)
	public override func viewWillAppear() {
		CNLog(logLevel: .detail, message: "viewWillAppear")
		super.viewWillAppear()
		doDumpView(message: "Last viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		CNLog(logLevel: .detail, message: "viewWillAppear")
		super.viewWillAppear(animated)
		doDumpView(message: "Last viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		CNLog(logLevel: .detail, message: "viewDidAppear")
		super.viewDidAppear()
		doDumpView(message: "Last viewDidAppear")
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		CNLog(logLevel: .detail, message: "viewDidAppear")
		super.viewDidAppear(animated)
		doDumpView(message: "Last viewDidAppear")
	}
	#endif

	private func allocateValue() -> CNCollectionInterface {
		let newelm: Array<CNValue> = [
			.stringValue("Hello, world !!"),
			.stringValue("Good, morning !!")
		]
		let newsec0 = CNCollectionValue.newSection(header: "Header-0", footer: "Footer-0", elements: newelm)
		let newsec1 = CNCollectionValue.newSection(header: "Header-1", footer: "Footer-1", elements: newelm)
		let newcol = CNCollectionValue()
		newcol.addSection(section: newsec0)
		newcol.addSection(section: newsec1)
		return newcol
	}

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			if CNPreference.shared.systemPreference.logLevel.isIncluded(in: .detail) {
				let cons = CNLogManager.shared.console
				cons.print(string: msg + "\n")
				let dumper = KCViewDumper()
				dumper.dump(view: view, console: cons)
			}
		} else {
			fatalError("No root view")
		}
	}
}


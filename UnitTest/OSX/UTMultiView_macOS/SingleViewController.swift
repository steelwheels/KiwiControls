/**
 * @file SingleView0Controller.swift
 * @brief Define SingleView0Controller. class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import KiwiControls
import Cocoa
import Foundation

public class SingleViewController: KCSingleViewController
{
	public enum Mode {
		case vertBox
		case horizBox
	}

	private var mMode:	Mode
	private var mCellTable:	KCCellTable

	public init(parentViewController parent: KCMultiViewController, mode md: Mode){
		mMode      = md
		mCellTable = KCCellTable()
		super.init(parentViewController: parent)
	}

	public required init?(coder: NSCoder) {
		mMode      = .vertBox
		mCellTable = KCCellTable()
		super.init(coder: coder)
	}

	public override func loadContext() -> KCView? {
		let result: KCView?
		switch mMode {
		case .vertBox:
			result = loadVertContext()
		case .horizBox:
			result = loadHolizContext()
		}
		return result
	}

	private func loadVertContext() -> KCView? {
		let label0    = KCTextEdit()
		label0.text   = "Hello, world. This is label0"

		let button0   = KCButton()
		button0.title = "OK"

		let box0 = KCStackView()
		box0.axis		= .horizontal
		box0.alignment		= .fill
		box0.distribution	= .fillEqually
		box0.addArrangedSubViews(subViews: [label0, button0])

		let edit1   = KCTextEdit()
		let icon1   = allocateIcon()
		let box1    = KCStackView()
		box1.axis		= .vertical
		box1.alignment		= .fill
		box1.distribution	= .fillEqually
		box1.addArrangedSubViews(subViews: [box0, icon1, edit1])

		return box1
	}

	private func loadHolizContext() -> KCView? {
		guard let imgurl = CNFilePath.URLForResourceFile(fileName: "amber-icon-128x128", fileExtension: "png") else {
			NSLog("No resource file")
			return nil
		}
		guard let img0 = NSImage(contentsOf: imgurl) else {
			NSLog("No image at \(imgurl.path)")
			return nil
		}
		let imgview0 = KCImageView()
		imgview0.set(image: img0)

		let edit1  = KCTextEdit()
		edit1.mode = .view(20)
		edit1.text = "This is label"

		let gr2d1  = allocateGraphics2DView()

		let button1   = KCButton()
		button1.title = "Select Home Directory"

		let box1 = KCStackView()
		box1.axis		= .horizontal
		box1.alignment		= .fill
		box1.distribution	= .fillProportinally
		box1.addArrangedSubViews(subViews: [edit1, gr2d1, button1])

		let icon1     = allocateIcon()
		let lstack    = allocateLabeledStack(image: img0)
		let table     = allocateTableView()
		let button2   = KCButton()
		button2.title = "OK"

		let box2 = KCStackView()
		box2.axis = .vertical
		box2.addArrangedSubViews(subViews: [imgview0, box1, icon1, lstack, table, button2])
		//box2.addArrangedSubViews(subViews: [box1, button2])

		return box2
	}

	private func allocateIcon() -> KCIconView {
		let icon   = KCIconView()
		icon.title = "Icon Title"
		if let imgurl = CNFilePath.URLForResourceFile(fileName: "steel-wheels", fileExtension: "png") {
			NSLog("URL of Icon: \(imgurl.path)")
			icon.image = CNImage.init(contentsOfFile: imgurl.path)
			icon.scale = 0.2
			icon.buttonPressedCallback = {
				() -> Void in
				NSLog("Icon pressed")
			}
		} else {
			NSLog("Invalid URL of image")
		}
		return icon
	}

	private func allocateLabeledStack(image img: CNImage) -> KCLabeledStackView {
		let imgview = KCImageView()
		imgview.set(image: img)
		imgview.scale = 0.5

		let lstack  = KCLabeledStackView()
		lstack.title = "Labeled Stack"
		lstack.contentsView.addArrangedSubView(subView: imgview)
		return lstack
	}

	private func allocateTableView() -> KCTableView {
		let view = KCTableView()

		let name0 = "a"
		NSLog("Add column (0.0)")
		let _ = mCellTable.addColumn(title: name0)
		for i in 0..<10 {
			mCellTable.append(colmunName: name0, value: .numberValue(NSNumber(integerLiteral: i)))
		}

		let name1 = "b"
		NSLog("Add column (1.0)")
		let _ = mCellTable.addColumn(title: name1)
		for i in 0..<10 {
			mCellTable.append(colmunName: name1, value: .numberValue(NSNumber(integerLiteral: 10 + i)))
		}

		NSLog("Set database")
		view.numberOfVisibleRows = 4
		view.cellTable           = mCellTable
		view.cellPressedCallback = {
			(_ col: Int, _ row: Int) -> Void in
			NSLog("Double cliked col=\(col) row=\(row)")
		}
		return view
	}

	private func allocateGraphics2DView() -> KCGraphics2DView {
		let newview = UTGraphics2DView()
		//newview.setTimer(doUse: true, interval: 1.0)
		return newview
	}

	public override func viewDidLoad() {
		CNLog(logLevel: .debug, message: "viewDidLoad")
		super.viewDidLoad()
	}

	#if os(OSX)
	public override func viewWillAppear() {
		CNLog(logLevel: .debug, message: "viewWillAppear")
		super.viewWillAppear()
		doDumpView(message: "Last viewWillAppear")
	}
	#else
	public override func viewWillAppear(_ animated: Bool) {
		CNLog(logLevel: .debug, message: "viewWillAppear")
		super.viewWillAppear(animated)
		doDumpView(message: "Last viewWillAppear")
	}
	#endif

	#if os(OSX)
	public override func viewDidAppear() {
		CNLog(logLevel: .debug, message: "viewDidAppear")
		super.viewDidAppear()
		doDumpView(message: "Last viewDidAppear")
	}
	#else
	public override func viewDidAppear(_ animated: Bool) {
		CNLog(logLevel: .debug, message: "viewDidAppear")
		super.viewDidAppear(animated)
		doDumpView(message: "Last viewDidAppear")
	}
	#endif

	private func doDumpView(message msg: String){
		if let view = self.rootView {
			if CNPreference.shared.systemPreference.logLevel.isIncluded(in: .detail) {
				if let cons = KCLogManager.shared.console {
					cons.print(string: msg + "\n")
					let dumper = KCViewDumper()
					dumper.dump(view: view, console: cons)
				} else {
					NSLog("No log console")
				}
			}
		} else {
			fatalError("No root view")
		}
	}
}


public class UTGraphics2DView: KCGraphics2DView {
	open override func draw(graphicsContext ctxt: CNGraphicsContext, count cnt: Int32) {
		NSLog("UTGraphics2DView: \(cnt)")
	}
}

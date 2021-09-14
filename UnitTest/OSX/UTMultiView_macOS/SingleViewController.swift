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

	private var mMode:		Mode
	private var mTableView:		KCTableView

	public init(parentViewController parent: KCMultiViewController, mode md: Mode){
		mMode      = md
		mTableView = KCTableView()
		super.init(parentViewController: parent)
	}

	public required init?(coder: NSCoder) {
		mMode      = .vertBox
		mTableView = KCTableView()
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
		button0.value = .text("OK")

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
		guard let imgurl = CNFilePath.URLForResourceFile(fileName: "steel-wheels", fileExtension: "png", subdirectory: nil, forClass: SingleViewController.self) else {
			CNLog(logLevel: .error, message: "No resource file", atFunction: #function, inFile: #file)
			return nil
		}
		guard let img0 = NSImage(contentsOf: imgurl) else {
			CNLog(logLevel: .error, message: "No image at \(imgurl.path)", atFunction: #function, inFile: #file)
			return nil
		}
		let imgview0 = KCImageView()
		imgview0.set(image: img0)
		imgview0.scale = 0.2

		let edit1  = KCTextEdit()
		edit1.format = .line
		edit1.isEditable = false
		edit1.text = "This is label"

		let gr2d1  = allocateGraphics2DView()
		let pmenu  = allocatePopupMenu()

		let button1   = KCButton()
		button1.value = .text("Select Home Directory")

		let box1 = KCStackView()
		box1.axis		= .horizontal
		box1.alignment		= .fill
		box1.distribution	= .fillProportinally
		box1.addArrangedSubViews(subViews: [edit1, gr2d1, pmenu, button1])

		let icon1     = allocateIcon()
		let button2   = KCButton()
		button2.value = .text("OK")

		let labstack = KCLabeledStackView()
		labstack.title = "Labeled Stack"

		let button30 = KCButton()
		button30.value = .text("First name")
		let button31 = KCButton()
		button31.value = .text("Given name")
		let box3 = KCStackView()
		box3.axis = .horizontal
		box3.addArrangedSubViews(subViews: [button30, button31])
		labstack.addArrangedSubViews(subViews: [value32, value33, box3])

		let box2 = KCStackView()
		box2.axis = .vertical
		box2.addArrangedSubViews(subViews: [imgview0, box1, icon1, labstack, button2])

		return box2
	}

	private func allocateIcon() -> KCIconView {
		let icon   = KCIconView()
		icon.title = "Icon Title"
		if let imgurl = CNFilePath.URLForResourceFile(fileName: "steel-wheels", fileExtension: "png", subdirectory: nil, forClass: SingleViewController.self) {
			CNLog(logLevel: .detail, message: "URL of Icon: \(imgurl.path)")
			icon.image = CNImage.init(contentsOfFile: imgurl.path)
			icon.scale = 0.2
			icon.buttonPressedCallback = {
				() -> Void in
				CNLog(logLevel: .detail, message: "Icon pressed")
			}
		} else {
			CNLog(logLevel: .error, message: "Invalid URL of image")
		}
		return icon
	}

	private func allocateGraphics2DView() -> KCGraphics2DView {
		let newview = UTGraphics2DView()
		//newview.setTimer(doUse: true, interval: 1.0)
		return newview
	}

	private func allocatePopupMenu() -> KCPopupMenu {
		let newmenu = KCPopupMenu()
		newmenu.addItems(withTitles: ["hello", "good morning"])
		newmenu.callbackFunction = {
			(_ index: Int, _ title: String?) -> Void in
			CNLog(logLevel: .error, message: "PopupMenu: select idx=\(index) title=\(String(describing: title))")
		}
		return newmenu ;
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


public class UTGraphics2DView: KCGraphics2DView {
	open override func draw(graphicsContext ctxt: CNGraphicsContext, count cnt: Int32) {
		CNLog(logLevel: .detail, message: "UTGraphics2DView: \(cnt)")
	}
}

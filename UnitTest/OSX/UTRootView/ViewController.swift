//
//  ViewController.swift
//  UTRootView
//
//  Created by Tomoo Hamada on 2018/05/05.
//  Copyright © 2018年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mRootView: KCRootView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		let frame    = mRootView.frame
		var txtframe = frame
		txtframe.size.height = 20.0

		let button = KCButton()
		let text   = KCTextEdit(frame: txtframe)
		let image  = KCImageView()
		if let url = CNFilePath.URLForResourceFile(fileName: "SampleImage0", fileExtension: "jpeg", subdirectory: "Images") {
			image.resource = url
		} else {
			NSLog("[Error] Failed to load SampleImage0.jpeg")
		}

		let box    = KCStackView(frame: frame)
		box.addArrangedSubView(subView: image)
		box.addArrangedSubView(subView: text)
		box.addArrangedSubView(subView: button)

		mRootView.setup(childView: box)
	}

	override func viewDidAppear() {
		super.viewDidAppear()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}


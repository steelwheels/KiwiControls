/**
 * @file	KCMainViewController.swift
 * @brief	Define KCMainViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls
import CoconutData

class MainViewController: KCViewController
{
	@IBOutlet weak var mRootView: KCRootView!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Do any additional setup after loading the view, typically from a nib.
		let console = KCLogConsole()
		console.print(string: "mainViewController: viewDidLoad\n")

		// Do any additional setup after loading the view.
		let frame  = mRootView.frame
		let button = KCButton()
		let label  = KCTextField()
		label.text = "Label"
		let text   = KCTextEdit()

		// allocate image view
		let image  = KCImageView()
		if let url = CNFilePath.URLForResourceFile(fileName: "SampleImage0", fileExtension: "jpeg", subdirectory: "Images") {
			image.resource = url
		} else {
			NSLog("[Error] Failed to load SampleImage0.jpeg")
		}

		// allocate stack view
		let box    = KCStackView(frame: frame)
		box.addArrangedSubViews(subViews: [label, image, text, button])

		mRootView.setup(childView: box)

		//let size = self.preferredContentSize
		let layouter = KCLayouter(rootSize: contentsSize(), console: console)
		layouter.layout(rootView: mRootView)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


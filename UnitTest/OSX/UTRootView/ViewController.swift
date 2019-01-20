//
//  ViewController.swift
//  UTRootView
//
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: KCViewController
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
			CNLog(type: .Error, .message: "Failed to load SampleImage0.jpeg", place: #file)
		}

		let box    = KCStackView(frame: frame)
		box.addArrangedSubView(subView: image)
		box.addArrangedSubView(subView: text)
		box.addArrangedSubView(subView: button)

		mRootView.setup(viewController: self, childView: box)
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


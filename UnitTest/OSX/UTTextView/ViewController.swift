//
//  ViewController.swift
//  UTTextView
//
//  Created by Tomoo Hamada on 2021/03/29.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController
{
	@IBOutlet weak var mTextView: KCTextView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let codes: Array<CNEscapeCode> = [
			.string("Hello, World !!\n"),
			.boldCharacter(true),
			.string("Good "),
			.boldCharacter(false),
			.string("Morning")
		]
		mTextView.execute(escapeCodes: codes)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


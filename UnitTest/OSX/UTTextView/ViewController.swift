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

		mTextView.isEditable = true

		var longstr: String = ""
		for i in 0..<1024 {
			longstr += "\(i) "
		}

		let codes: Array<CNEscapeCode> = [
			.string("Hello, World !!\n"),
			.boldCharacter(true),
			.string("Good "),
			.boldCharacter(false),
			.string("Morning,"),
			.foregroundColor(CNColor.yellow),
			.backgroundColor(CNColor.blue),
			.string("Good Evening"),
			.defaultForegroundColor,
			.defaultBackgroundColor,
			.string(longstr),
		]
		mTextView.execute(escapeCodes: codes)
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


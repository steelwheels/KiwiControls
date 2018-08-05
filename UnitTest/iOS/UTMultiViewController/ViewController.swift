/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import KiwiControls

class ViewController: KCMultiViewController
{
	override func viewDidLoad() {
		NSLog("ViewController: viewDidLoad")

		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func viewWillAppear(_ animated: Bool) {
		NSLog("ViewController: viewWillAppear/0")
		let label0 = KCTextField(frame: CGRect(x: 0.0, y: 0.0, width: 128.0, height: 16.0))
		label0.text = "Label 0"
		let dlg0   = UTSingleViewDelegate(contentView: label0)
		add(name: "label0", delegate: dlg0)

		NSLog("ViewController: viewWillAppear/1")
		let label1 = KCTextField(frame: CGRect(x: 0.0, y: 0.0, width: 128.0, height: 16.0))
		label1.text = "Label 1"
		let dlg1   = UTSingleViewDelegate(contentView: label1)
		add(name: "label1", delegate: dlg1)

		NSLog("ViewController: viewWillAppear/2")
		self.selectedIndex = 1

		NSLog("ViewController: viewWillAppear/E")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


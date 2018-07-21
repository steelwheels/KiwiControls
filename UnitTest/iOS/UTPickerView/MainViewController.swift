//
//  ViewController.swift
//  UTPickerView
//
//  Created by Tomoo Hamada on 2018/07/16.
//  Copyright © 2018年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import UIKit

class MainViewController: UIViewController, UIDocumentPickerDelegate
{
	private var mDocumentPicker: UIDocumentPickerViewController? = nil

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		// Do any additional setup after loading the view, typically from a nib.
		let picker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.keynote.keynote"], in: .open)
		picker.delegate = self
		present(picker, animated: true, completion: {
			() -> Void in
			NSLog("Finished\n")
		})
		mDocumentPicker = picker
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


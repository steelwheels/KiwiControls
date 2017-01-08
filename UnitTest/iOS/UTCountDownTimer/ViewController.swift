//
//  ViewController.swift
//  UTCountDownTimer
//
//  Created by Tomoo Hamada on 2016/12/01.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: KCViewController
{
	@IBOutlet weak var mTextField: KCTextField!
	private var mTimer: KCTimer? = nil

	override func viewDidLoad() {
		super.viewDidLoad()

		let timer = KCTimer()
		timer.updateCallback = {
			(time:TimeInterval) -> Bool in
			self.mTextField.setDouble(value: time)
			return true
		}
		timer.doneCallback = {
			() -> Void in
			self.mTextField.text = "Done"
		}
		timer.start(startValue: 4.0, stopValue: 0.0, stepValue: -1.0)
		mTimer = timer
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


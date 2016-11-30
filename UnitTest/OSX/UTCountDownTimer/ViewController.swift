//
//  ViewController.swift
//  UTCountDownTimer
//
//  Created by Tomoo Hamada on 2016/12/01.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KiwiControls

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		timerTest()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	private func timerTest() -> Void {
		let timer = KCCountDownTimer(startValue: 5.0, stepValue: 1.0)
		timer.updateCallback = {
			(_ time:TimeInterval) -> Bool in
				Swift.print("timerValue: \(time)")
				return true
		}
		timer.doneCallback = {
			() -> Void in
				Swift.print("done")
		}
		timer.start()
	}
}


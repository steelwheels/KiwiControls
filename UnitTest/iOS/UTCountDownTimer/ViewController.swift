//
//  ViewController.swift
//  UTCountDownTimer
//
//  Created by Tomoo Hamada on 2016/12/01.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		timerTest()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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


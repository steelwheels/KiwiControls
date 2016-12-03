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

	@IBOutlet weak var mTimerView: KCTimerView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let timestate = KCTimerState(startValue: 5.0, stepValue: 1.0)
		state = timestate
		mTimerView.state = timestate
		timestate.start()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	open override func observe(state s: CNState){
		if let timestate = state as? KCTimerState {
			let time = timestate.currentTime
			Swift.print("timerValue: \(time)")
		} else {
			fatalError("Invalid state object")
		}
	}

	/*
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
	*/
}


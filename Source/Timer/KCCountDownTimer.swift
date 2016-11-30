/**
 * @file	KCCountDownTimer.swift
 * @brief	Define KCCountDownTimer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
#if os(OSX)
	import Cocoa
#endif
#if os(iOS)
	import UIKit
#endif

public class KCCountDownTimer
{
	private var mStartValue:	TimeInterval
	private var mStepValue:		TimeInterval
	private var mCurrentValue:	TimeInterval

	public var updateCallback: ((_ time:TimeInterval) -> Bool)? = nil
	public var doneCallback: (() -> Void)? = nil

	public init(startValue start: TimeInterval, stepValue step: TimeInterval){
		mStartValue	= start
		mStepValue	= step
		mCurrentValue	= start
	}

	public func start(){
		mCurrentValue = mStartValue
		let timer = Timer.scheduledTimer(timeInterval: mStepValue, target: self, selector: #selector(KCCountDownTimer.update(_:)), userInfo: nil, repeats: true)
		RunLoop.current.add(timer, forMode: .commonModes)
	}

	@objc func update(_ timer: Timer){
		if timer.isValid {
			var donetimer = false
			mCurrentValue = mCurrentValue - mStepValue
			if let updatecb = updateCallback {
				if !updatecb(mCurrentValue){
					donetimer = true
				}
			}
			if mCurrentValue <= 0.0 {
				donetimer = true
			}
			if donetimer {
				if let donecb = doneCallback {
					donecb()
				}
				timer.invalidate()
			}
		}
	}
}

/**
 * @file	KCTimer.swift
 * @brief	Define KCTimer class
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

public class KCTimer
{
	private enum CountType {
		case CountUp
		case CountDown
	}

	private var mCountType:		CountType
	private var mStartValue:	TimeInterval
	private var mStopValue:		TimeInterval
	private var mStepValue:		TimeInterval
	private var mCurrentValue:	TimeInterval

	public var updateCallback: ((_ time:TimeInterval) -> Bool)? = nil
	public var doneCallback: (() -> Void)? = nil

	public init(startValue start: TimeInterval, stopValue stop: TimeInterval, stepValue step: TimeInterval){
		if start <= stop {
			mCountType = .CountUp
		} else {
			mCountType = .CountDown
		}
		mStartValue	= start
		mStopValue	= stop
		mStepValue	= step
		mCurrentValue	= start
	}

	public func start(){
		mCurrentValue = mStartValue
		let interval = abs(mStepValue)
		let timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(KCTimer.update(_:)), userInfo: nil, repeats: true)
		RunLoop.current.add(timer, forMode: .commonModes)
	}

	@objc func update(_ timer: Timer){
		if timer.isValid {
			var donetimer = false
			mCurrentValue = mCurrentValue + mStepValue

			if let updatecb = updateCallback {
				if !updatecb(mCurrentValue){
					donetimer = true
				}
			}

			switch mCountType {
			case .CountUp:
				if mCurrentValue > mStopValue {
					donetimer = true
				}
			case .CountDown:
				if mCurrentValue <= mStopValue {
					donetimer = true
				}
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

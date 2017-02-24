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

public typealias KCTimerUpdateCallback = (_ time: TimeInterval) -> Void
public typealias KCTimerDoneCallback   = () -> Void

public class KCTimer
{
	private enum CountType {
		case CountUp
		case CountDown
	}

	struct Callback {
		var interval:		TimeInterval
		var currentTime:	TimeInterval
		var callback:		KCTimerUpdateCallback
	}

	private var mCountType:		CountType
	private var mStartValue:	TimeInterval
	private var mStopValue:		TimeInterval
	private var mStepValue:		TimeInterval
	private var mCurrentValue:	TimeInterval

	private var mUpdateCallbacks:	Array<Callback>
	private var mDoneCallbacks:	Array<KCTimerDoneCallback>

	public init(){
		mCountType	= .CountDown
		mStartValue	= 0.0
		mStopValue	= 0.0
		mStepValue	= 0.0
		mCurrentValue	= 0.0

		mUpdateCallbacks = []
		mDoneCallbacks	 = []
	}

	public func addUpdateCallback(interval intvl: TimeInterval, callback cbck: @escaping KCTimerUpdateCallback){
		let newitem = Callback(interval: intvl, currentTime: 0.0, callback: cbck)
		mUpdateCallbacks.append(newitem)
	}

	public func clearUpdateCallback(){
		mUpdateCallbacks = []
	}

	public func addDoneCallback(callback cbck: @escaping KCTimerDoneCallback){
		mDoneCallbacks.append(cbck)
	}

	public func clearDoneCallback(){
		mDoneCallbacks = []
	}

	public func start(startValue start: TimeInterval, stopValue stop: TimeInterval, stepValue step: TimeInterval){
		guard start != stop && step != 0.0 else {
			return
		}

		if start <= stop {
			mCountType = .CountUp
		} else {
			mCountType = .CountDown
		}
		mStartValue	= start
		mStopValue	= stop
		mStepValue	= step
		mCurrentValue	= start

		let interval = abs(mStepValue)
		let timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(KCTimer.update(_:)), userInfo: nil, repeats: true)
		RunLoop.current.add(timer, forMode: .commonModes)
	}

	@objc func update(_ timer: Timer){
		if timer.isValid {
			mCurrentValue = mCurrentValue + mStepValue

			/* Call update callbacks */
			for i in 0..<mUpdateCallbacks.count {
				let interval = abs(mStepValue)
				mUpdateCallbacks[i].currentTime += interval
				if mUpdateCallbacks[i].currentTime >= mUpdateCallbacks[i].interval {
					let callback = mUpdateCallbacks[i].callback
					callback(mCurrentValue)
					mUpdateCallbacks[i].currentTime = 0.0
				}
			}

			var donetimer = false
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
				for callback in mDoneCallbacks {
					callback()
				}
				timer.invalidate()
			}
		}
	}
}

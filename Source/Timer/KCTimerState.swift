/**
 * @file	KCTimerState.swift
 * @brief	Define KCTimerState class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import Canary

public class KCTimerState: CNState
{
	public enum TimerState {
		case idle
		case work
		case stop
	}

	public var timerState	: TimerState
	public var currentTime	: TimeInterval

	private var mStartValue	: TimeInterval
	private var mStepValue	: TimeInterval

	private var mTimer: KCCountDownTimer? = nil

	public init(startValue start: TimeInterval, stepValue step: TimeInterval){
		timerState	= .idle
		mStartValue	= start
		mStepValue	= step
		currentTime	= start
		super.init()
	}

	public func start(){
		let timer = KCCountDownTimer(startValue: mStartValue, stepValue: mStepValue)
		timer.updateCallback = {
			(_ time:TimeInterval) -> Bool in
				self.timerState  = .work
				self.currentTime = time
				super.updateState()
				return true
		}
		timer.doneCallback = {
			() -> Void in
				self.timerState = .stop
				super.updateState()
		}
		timer.start()
		mTimer = timer
	}
}


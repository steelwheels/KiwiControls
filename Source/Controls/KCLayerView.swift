/**
 * @file	KCLayerView.swift
 * @brief	Define KCLayerView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 * reference: https://stackoverflow.com/questions/2306870/is-there-a-way-to-pause-a-cabasicanimation
 */

import CoconutData
import CoreGraphics
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

#if os(OSX)
public protocol KCLayerDelegate: CALayerDelegate, CAAnimationDelegate {
}
#else
public protocol KCLayerDelegate {
}
#endif

public class KCLayer: CALayer {
	public static let RepeatCountKey = "repeatCount"

	class public override func needsDisplay(forKey key: String) -> Bool {
		if key == RepeatCountKey {
			return true
		} else {
			return super.needsDisplay(forKey: key)
		}
	}
}

open class KCLayerView: KCView, KCLayerDelegate
{
	public typealias UpdateStateCallback = (_ state: CNAnimationState) -> Void

	private let LayerSpeed: Float	= 1.0

	private var mMinimumSize:	KCSize
	private var mLogicalFrame:	CGRect
	private var mAnimationState:	CNAnimationState
	private var mStateCallback:	UpdateStateCallback?
	private var mDrawCount:		Int32

	public override init(frame: KCRect) {
		mMinimumSize	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= KCRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		mAnimationState	= .idle
		mStateCallback	= nil
		mDrawCount	= 0
		super.init(frame: frame)
		setup()
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		stopAsync()
	}

	private func setup() {
		#if os(OSX)
		let newlayer	  = KCLayer()
		self.layer        = newlayer
		newlayer.delegate = self
		self.wantsLayer   = true
		#endif
	}

	private func getLayer() -> CALayer {
		#if os(OSX)
		if let lay = self.layer {
			return lay
		} else {
			fatalError("Can not happen at \(#function)")
		}
		#else
		return self.layer
		#endif
	}

	public var minimumSize: KCSize {
		get { return mMinimumSize }
		set(newsize) {
			if newsize.width > 0.0 && newsize.height > 0.0 {
				mMinimumSize = newsize
				self.invalidateIntrinsicContentSize()
			}
		}
	}

	public var logicalFrame: CGRect {
		get { return mLogicalFrame }
		set(newfrm) {
			if newfrm.size.width > 0.0 && newfrm.size.height > 0.0 {
				mLogicalFrame = newfrm
			} else {
				NSLog("[Error] Invalid frame size at \(#function)")
			}
		}
	}

	public func setCallback(updateStateCallback cbfunc: @escaping UpdateStateCallback) {
		mStateCallback = cbfunc
	}

	public var state: CNAnimationState {
		get { return mAnimationState }
	}

	private func updateState(state stat: CNAnimationState) {
		if mAnimationState != stat {
			mAnimationState = stat
			if let cbfunc = mStateCallback {
				cbfunc(stat)
			}
		}
	}
	
	public func start(interval intvl: TimeInterval, endTime etime: Float) {
		switch mAnimationState {
		case .idle:
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				self.startAsync(interval: intvl, endTime: etime)
			})
		case .run, .pause:
			NSLog("Already running: \(mAnimationState.description)")
		@unknown default:
			NSLog("Unknown state")
		}
	}

	public func stop() {
		switch mAnimationState {
		case .idle:
			NSLog("Already stopped")
		case .run, .pause:
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				self.stopAsync()
			})
		@unknown default:
			NSLog("Unknown state")
		}
	}

	public func suspend(){
		switch mAnimationState {
		case .idle:
			NSLog("Already idle")
		case .pause:
			NSLog("Already pause")
		case .run:
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				self.suspendAsync()
			})
		@unknown default:
			NSLog("Unknown state")
		}
	}

	public func resume(){
		switch mAnimationState {
		case .idle:
			NSLog("Already idle")
		case .run:
			NSLog("Already run")
		case .pause:
			CNExecuteInMainThread(doSync: false, execute: {
				() -> Void in
				self.resumeAsync()
			})
		@unknown default:
			NSLog("Unknown state")
		}
	}

	private func startAsync(interval intvl: TimeInterval, endTime etime: Float) {
		switch mAnimationState {
		case .idle:
			/* Reset the count */
			mDrawCount = 0

			let timer = CABasicAnimation(keyPath: KCLayer.RepeatCountKey)
			timer.duration	  		= intvl
			timer.repeatCount 		= etime
			timer.isRemovedOnCompletion	= true
			#if os(OSX)
			timer.delegate			= self
			#endif

			let lay		= getLayer()
			lay.speed   	= LayerSpeed
			CATransaction.begin()
			lay.add(timer, forKey: KCLayer.RepeatCountKey)
			CATransaction.commit()

			updateState(state: .run)
		case .pause, .run:
			NSLog("Not idle state at \(#function)")
		@unknown default:
			NSLog("Unknown state at \(#function)")
		}
	}

	private func stopAsync() {
		switch mAnimationState {
		case .idle, .pause:
			NSLog("Not run state at \(#function)")
		case .run:
			let lay		= getLayer()
			lay.speed   	= 0.0		/* Stop animation */
			lay.removeAllAnimations()

			updateState(state: .idle)
		@unknown default:
			NSLog("Unknown state at \(#function)")
		}
	}

	private func suspendAsync() {
		switch mAnimationState {
		case .run:
			let lay		   	= getLayer()
			let pausedTime     	= lay.convertTime(CACurrentMediaTime(), from: nil)
			lay.speed         	= 0.0	/* Stop animation */
			lay.timeOffset 	   	= pausedTime

			updateState(state: .pause)
		case .idle, .pause:
			NSLog("Not run state at \(#function)")
		@unknown default:
			NSLog("Unknown state at \(#function)")
		}

	}

	private func resumeAsync() {
		switch mAnimationState {
		case .pause:
			let lay			= getLayer()
			let pausedTime  	= lay.timeOffset
			lay.speed   		= LayerSpeed
			lay.timeOffset		= 0.0
			let timeSincePause	= lay.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
			lay.beginTime		= timeSincePause

			updateState(state: .run)
		case .idle, .run:
			NSLog("Not pause state at \(#function)")
		@unknown default:
			NSLog("Unknown state at \(#function)")
		}
	}

	public func animationDidStart(_ anim: CAAnimation) {
		NSLog("didstart")
	}

	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		NSLog("didstop finished:\(flag)")
		stopAsync()
	}

	open override func draw(_ dirtyRect: KCRect) {
		if let ctxt = self.context {
			draw(context: ctxt, count: mDrawCount)
			mDrawCount = (mDrawCount == Int32.max) ? 1 : mDrawCount + 1
		} else {
			NSLog("[Error] No context at \(#function)")
		}
	}

	#if os(OSX)
	private var context: CGContext? {
		get { return NSGraphicsContext.current?.cgContext }
	}
	#else
	private var context: CGContext? {
		get { return UIGraphicsGetCurrentContext() }
	}
	#endif

	open func draw(context ctxt: CGContext, count cnt: Int32) {
		NSLog("draw layer: \(cnt)")
	}

	public override var intrinsicContentSize: KCSize {
		get { return mMinimumSize }
	}
}


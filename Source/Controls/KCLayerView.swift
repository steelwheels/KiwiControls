/**
 * @file	KCLayerView.swift
 * @brief	Define KCLayerView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

import CoconutData
import CoreGraphics
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

#if os(OSX)
public protocol KCLayerDelegate: CALayerDelegate {
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
	private var mMinimumSize:	KCSize
	private var mLogicalFrame:	CGRect
	private var mDrawCount:		Int32
	private var mPausedSpeed:	Float

	public override init(frame: KCRect) {
		mMinimumSize	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= KCRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		mDrawCount	= 0
		mPausedSpeed	= 1.0
		super.init(frame: frame)
		setup()
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		stop()
	}

	private func setup() {
		#if os(OSX)
		self.layer = KCLayer()
		if let mylayer = self.layer {
			mylayer.delegate = self
		} else {
			NSLog("Error: No layer at \(#function)")
		}
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
	
	public func start(interval intvl: TimeInterval, endTime etime: Float) {
		let timer = CABasicAnimation(keyPath: KCLayer.RepeatCountKey)
		timer.duration	  		= intvl
		timer.repeatCount 		= etime
		timer.isRemovedOnCompletion	= true

		let lay = getLayer()
		CATransaction.begin()
		lay.add(timer, forKey: KCLayer.RepeatCountKey)
		CATransaction.commit()
	}

	public func stop() {
		let mylayer = getLayer()
		mylayer.removeAllAnimations()
	}

	public var isRunning: Bool {
		let mylayer = getLayer()
		if let keys = mylayer.animationKeys() {
			return keys.count > 0
		} else {
			return false
		}
	}

	/* reference: https://stackoverflow.com/questions/2306870/is-there-a-way-to-pause-a-cabasicanimation */
	public var isPaused: Bool {
		get {
			if self.isRunning {
				let mylayer = getLayer()
				return (mylayer.speed == 0.0)
			} else {
				return false
			}
		}
	}

	public func pause(){
		let mylayer = getLayer()
		let pausedTime     = mylayer.convertTime(CACurrentMediaTime(), from: nil)
		mPausedSpeed	   = mylayer.speed
		mylayer.speed      = 0
		mylayer.timeOffset = pausedTime
	}

	public func resume(){
		let mylayer		= getLayer()
		let pausedTime  	= mylayer.timeOffset
		mylayer.speed   	= mPausedSpeed
		mylayer.timeOffset	= 0.0
		mylayer.beginTime	= 0.0
		let timeSincePause	= mylayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
		mylayer.beginTime	= timeSincePause
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


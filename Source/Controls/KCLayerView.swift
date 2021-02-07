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

	public override init(frame: KCRect) {
		mMinimumSize	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= KCRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		mDrawCount	= 0
		super.init(frame: frame)
		setup()
	}

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
	
	public func animation(interval intvl: TimeInterval, endTime etime: Float) {
		let timer = CABasicAnimation(keyPath: KCLayer.RepeatCountKey)
		timer.duration	  = intvl
		timer.repeatCount = etime

		#if os(OSX)
		if let mylayer = self.layer {
			CATransaction.begin()
			mylayer.add(timer, forKey: KCLayer.RepeatCountKey)
			CATransaction.commit()
		} else {
			NSLog("[Error] No layer at \(#function)")
		}
		#else
		let mylayer = self.layer
		CATransaction.begin()
		mylayer.add(timer, forKey: KCLayer.RepeatCountKey)
		CATransaction.commit()
		#endif
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


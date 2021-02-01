/**
 * @file	KCGraphics2DView.swift
 * @brief	Define KCGraphics2DView class
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

open class KCGraphics2DView: KCView
{
	private var mContext:		CNGraphicsContext
	private var mMinimumSize:	KCSize
	private var mLogicalFrame:	CGRect
	private var mForegroundColor:	CNColor

	#if os(OSX)
	public override init(frame : NSRect){
		mContext     	= CNGraphicsContext()
		mMinimumSize 	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

		let pref = CNPreference.shared.viewPreference
		mForegroundColor = pref.foregroundColor

		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mContext     	= CNGraphicsContext()
		mMinimumSize	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

		let pref = CNPreference.shared.viewPreference
		mForegroundColor = pref.foregroundColor

		super.init(frame: frame)
	}
	#endif

	public convenience init(){
		let frame = KCRect(x: 0.0, y: 0.0, width: 480, height: 270)
		self.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mMinimumSize = KCSize(width: 128.0, height: 128.0)
		fatalError("init(coder:) has not been implemented")
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
				NSLog("Invalid frame size")
			}
		}
	}

	public var foregroundColor: CNColor { get { return mForegroundColor }}

	public override func draw(_ dirtyRect: KCRect) {
		super.draw(dirtyRect)
		mContext.begin(context: self.coreContext, logicalFrame: mLogicalFrame, physicalFrame: self.frame)
		/* Set default parameters */
		mContext.setFillColor(color:   mForegroundColor.cgColor)
		mContext.setStrokeColor(color: mForegroundColor.cgColor)
		mContext.setPenSize(width: mLogicalFrame.size.width / 100.0)
		draw(context: mContext)
		mContext.end()
	}

	open func draw(context ctxt: CNGraphicsContext) {
		NSLog("must be override at \(#function)")
	}

	public override var intrinsicContentSize: KCSize {
		get { return minimumSize }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(graphics2DView: self)
	}

	private var coreContext: CGContext {
		get {
			#if os(OSX)
			if let ctxt = NSGraphicsContext.current {
				return ctxt.cgContext
			} else {
				fatalError("Can not happen")
			}
			#else
			if let ctxt = UIGraphicsGetCurrentContext() {
				return ctxt
			} else {
				fatalError("Can not happen")
			}
			#endif
		}
	}
}


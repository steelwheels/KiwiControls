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

open class KCBaseGraphicsView: KCView
{
	private var mMinimumSize:	KCSize
	private var mLogicalFrame:	CGRect

	#if os(OSX)
	public override init(frame: NSRect) {
		mMinimumSize 	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect) {
		mMinimumSize 	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		super.init(frame: frame)
	}
	#endif

	public convenience init(){
		let frame = KCRect(x: 0.0, y: 0.0, width: 480, height: 270)
		self.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mMinimumSize 	= KCSize(width: 128.0, height: 128.0)
		mLogicalFrame	= CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
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

	public override var intrinsicContentSize: KCSize {
		get { return mMinimumSize }
	}

	public var cgContext: CGContext {
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

open class KCGraphics2DView: KCBaseGraphicsView
{
	private var mContext:		CNGraphicsContext
	private var mForegroundColor:	CNColor

	#if os(OSX)
	public override init(frame : NSRect){
		mContext     	= CNGraphicsContext()
		let pref = CNPreference.shared.viewPreference
		mForegroundColor = pref.foregroundColor

		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mContext = CNGraphicsContext()
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
		mContext = CNGraphicsContext()
		let pref = CNPreference.shared.viewPreference
		mForegroundColor = pref.foregroundColor
		super.init(coder: coder)
	}

	public var foregroundColor: CNColor { get { return mForegroundColor }}

	public override func draw(_ dirtyRect: KCRect) {
		super.draw(dirtyRect)
		mContext.begin(context: self.cgContext, logicalFrame: logicalFrame, physicalFrame: self.frame)
		/* Set default parameters */
		mContext.setFillColor(color:   mForegroundColor.cgColor)
		mContext.setStrokeColor(color: mForegroundColor.cgColor)
		mContext.setPenSize(width: logicalFrame.size.width / 100.0)
		draw(context: mContext)
		mContext.end()
	}

	open func draw(context ctxt: CNGraphicsContext) {
		NSLog("must be override at \(#function)")
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(graphics2DView: self)
	}
}

open class KCBitmapView: KCBaseGraphicsView
{
	private var mContext:		CNBitmapContext
	private var mRowCount:		Int
	private var mColumnCount:	Int

	#if os(OSX)
	public override init(frame : NSRect){
		mContext = CNBitmapContext()
		mRowCount     = 10
		mColumnCount  = 10
		super.init(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		mContext = CNBitmapContext()
		mRowCount     = 10
		mColumnCount  = 10
		super.init(frame: frame)
	}
	#endif

	public convenience init(){
		let frame = KCRect(x: 0.0, y: 0.0, width: 480, height: 270)
		self.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mContext = CNBitmapContext()
		mRowCount     = 10
		mColumnCount  = 10
		super.init(coder: coder)
	}

	public var rowCount: Int {
		get		{ return mRowCount }
		set(newval)	{ mRowCount = newval }
	}

	public var columnCount: Int {
		get		{ return mColumnCount   }
		set(newval)	{ mColumnCount = newval }
	}

	public override func draw(_ dirtyRect: KCRect) {
		super.draw(dirtyRect)
		mContext.begin(context: self.cgContext, physicalFrame: self.frame, width: mColumnCount, height: mRowCount)
		/* Set default parameters */
		draw(context: mContext)
		mContext.end()
	}

	open func draw(context ctxt: CNBitmapContext) {
		NSLog("must be override at \(#function)")
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(bitmapView: self)
	}
}


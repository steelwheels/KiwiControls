/**
 * @file	KCBitmapView.swift
 * @brief	Define KCBitmapView class
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

open class KCBitmapView: KCLayerView
{
	private var mContext:		CNBitmapContext
	private var mRowCount:		Int
	private var mColumnCount:	Int

	public override init(frame : KCRect){
		mContext     = CNBitmapContext()
		mRowCount    = 10
		mColumnCount = 10
		super.init(frame: frame)
	}

	public convenience init(){
		let frame = KCRect(x: 0.0, y: 0.0, width: 480, height: 270)
		self.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mContext     = CNBitmapContext()
		mRowCount    = 10
		mColumnCount = 10
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

	open override func draw(context ctxt: CGContext, count cnt: Int32) {
		self.mContext.begin(context: ctxt, physicalFrame: self.frame, width: self.mColumnCount, height: self.mRowCount)
		self.draw(bitmapContext: self.mContext, count: cnt)
		self.mContext.end()
	}

	open func draw(bitmapContext ctxt: CNBitmapContext, count cnt: Int32) {
		NSLog("must be override at \(#function) \(cnt)")
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(bitmapView: self)
	}
}


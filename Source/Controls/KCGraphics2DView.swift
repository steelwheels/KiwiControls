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

open class KCGraphics2DView: KCLayerView
{
	private var mContext:		CNGraphicsContext
	private var mForegroundColor:	CNColor

	public override init(frame : KCRect){
		mContext     	= CNGraphicsContext()
		let pref = CNPreference.shared.viewPreference
		mForegroundColor = pref.foregroundColor

		super.init(frame: frame)
	}

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

	open override func draw(context ctxt: CGContext, count cnt: Int32) {
		self.mContext.begin(context: ctxt, logicalFrame: self.logicalFrame, physicalFrame: self.frame)
		/* Set default parameters */
		if cnt == 0 {
			self.mContext.setFillColor(color:   self.mForegroundColor)
			self.mContext.setStrokeColor(color: self.mForegroundColor)
			self.mContext.setPenSize(width: self.logicalFrame.size.width / 100.0)
		}
		self.draw(graphicsContext: self.mContext, count: cnt)
		self.mContext.end()
	}

	open func draw(graphicsContext ctxt: CNGraphicsContext, count cnt: Int32) {
		NSLog("must be override at \(#function) \(cnt)")
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(graphics2DView: self)
	}
}


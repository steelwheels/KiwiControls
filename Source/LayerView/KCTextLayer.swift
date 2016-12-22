/**
 * @file	KCTextLayer.swift
 * @brief	Define KCTextLayer class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import KiwiGraphics
#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

open class KCTextLayer: KCLayer
{
	private var mFont:	KGFont
	private var mText:	String
	private var mColor:	CGColor
	private var mTextLayer:	CATextLayer?

	public init(frame frm: CGRect, font fnt:KGFont, color col: CGColor, text txt:String) {
		mFont		= fnt
		mColor		= col
		mText		= txt
		mTextLayer	= nil
		super.init(frame: frm)
		bounds     = KCTextLayer.calculateBounds(frame: frame, font: fnt, text: txt)
		//Swift.print("bounds0 = \(bounds.description)")
		let newlayer = KCTextLayer.allocateTextLayer(frame: bounds, font: fnt, color: col, text: txt)
		super.addSublayer(newlayer)
		mTextLayer = newlayer
	}
	
	public required init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func setText(text: String){
		if let layer = mTextLayer {
			let bnds = KCTextLayer.calculateBounds(frame: frame, font: mFont, text: text)
			//Swift.print("bounds1 = \(bnds.description)")
			layer.string	= text
			layer.frame	= bnds
			self.setNeedsDisplay()
		} else {
			fatalError("No text layer")
		}
	}

	public func setDouble(value: Double){
		let valstr = String(format: "%4.2f", value)
		Swift.print("\(valstr)")
		setText(text: valstr)
	}

	open override func drawContent(in context: CGContext){
		if let tlayer = mTextLayer {
			tlayer.draw(in: context)
		}
	}

	private class func allocateTextLayer(frame frm: CGRect, font fnt:KGFont, color col: CGColor, text txt:String) -> CATextLayer {
		let textLayer = CATextLayer()
		textLayer.string		= txt
		textLayer.font			= fnt
		textLayer.fontSize		= fnt.pointSize
		textLayer.foregroundColor	= col
		textLayer.frame			= frm
		textLayer.alignmentMode = kCAAlignmentCenter
		//textLayer.contentsScale = UIScreen.mainScreen().scale
		return textLayer
	}

	private class func calculateBounds(frame frm: CGRect, font fnt:KGFont, text txt:String) -> CGRect {
		let attributes: [String: AnyObject] = [NSFontAttributeName:fnt]
		#if os(iOS)
			let textsize = txt.size(attributes: attributes)
		#else
			let textsize = txt.size(withAttributes: attributes)
		#endif
		return KGAlignRect(holizontalAlignment: .center,
		                   verticalAlignment:   .middle,
		                   targetSize:          textsize,
		                   in:			frm) //CGRect(origin: CGPoint.zero, size: frm.size))
	}
}


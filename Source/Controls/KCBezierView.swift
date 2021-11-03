/*
 * @file	KCBezierView.swift
 * @brief	Define KCBezierView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 * @par Reference
 *   https://stackoverflow.com/questions/47738822/simple-drawing-with-mouse-on-cocoa-swift
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCBezierView: KCView
{
	private var mBezierPath:	CNBezierPath
	private var mWidth:		CGFloat?
	private var mHeight:		CGFloat?

	public override init(frame: KCRect) {
		mBezierPath = CNBezierPath()
		mWidth	    = nil
		mHeight	    = nil
		super.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mBezierPath = CNBezierPath()
		mWidth	    = nil
		mHeight	    = nil
		super.init(coder: coder)
	}

	public var lineWidth: CGFloat {
		get	    { return mBezierPath.lineWidth	}
		set(newval) { mBezierPath.lineWidth = newval 	}
	}

	public var width: CGFloat? {
		get         { return mWidth    }
		set(newval) { mWidth = newval  }
	}

	public var height: CGFloat? {
		get         { return mHeight   }
		set(newval) { mHeight = newval }
	}

	public override func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		switch event {
		case .down:
			mBezierPath.addDown(point: position, in: self.frame.size)
		case .up:
			mBezierPath.addUp(point: position, in: self.frame.size)
		case .drag:
			mBezierPath.addDown(point: position, in: self.frame.size)
		}
		self.requireDisplay()
	}

	public override func draw(_ dirtyRect: KCRect) {
		let bezier = KCBezierPath(rect: self.bounds)
		bezier.lineJoinStyle = .round
		bezier.lineCapStyle  = .round
		bezier.lineWidth     = mBezierPath.lineWidth
		mBezierPath.forEach({
			(_ point: CNBezierPath.Path) -> Void in
			switch point {
			case .moveTo(let lpt):
				let ppt = logicalToPhysical(point: lpt, in: self.bounds)
				bezier.move(to: ppt)
			case .lineTo(let lpt):
				let ppt = logicalToPhysical(point: lpt, in: self.bounds)
				bezier.addLine(to: ppt)
			case .lineWidth(let wid):
				bezier.lineWidth = wid
			@unknown default:
				CNLog(logLevel: .error, message: "Can not happen", atFunction: #function, inFile: #file)
			}
		})
		bezier.stroke()
	}

	private func logicalToPhysical(point pt: CGPoint, in rect: CGRect) -> CGPoint {
		let x = pt.x * rect.size.width  + rect.origin.x
		let y = pt.y * rect.size.height + rect.origin.y
		return CGPoint(x: x, y: y)
	}

	public override var intrinsicContentSize: KCSize {
		get {
			let ssize  = super.intrinsicContentSize
			let width  = mWidth  != nil ? mWidth!  : ssize.width
			let height = mHeight != nil ? mHeight! : ssize.height
			return KCSize(width: width, height: height)
		}
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(bezierView: self)
	}
}


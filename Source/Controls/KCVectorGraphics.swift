/*
 * @file	KCVectorGraphics.swift
 * @brief	Define KCVectorGraphics class
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

open class KCVectorGraphics: KCView
{
	private var mGenerator:		CNVecroGraphicsGenerator
	private var mWidth:		CGFloat?
	private var mHeight:		CGFloat?

	public override init(frame: KCRect) {
		mGenerator  = CNVecroGraphicsGenerator()
		mWidth	    = nil
		mHeight	    = nil
		super.init(frame: frame)
	}

	required public init?(coder: NSCoder) {
		mGenerator  = CNVecroGraphicsGenerator()
		mWidth	    = nil
		mHeight	    = nil
		super.init(coder: coder)
	}

	public var lineWidth: CGFloat {
		get	    { return mGenerator.lineWidth	}
		set(newval) { mGenerator.lineWidth = newval 	}
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
			mGenerator.addDown(point: position, in: self.frame.size)
		case .up:
			mGenerator.addUp(point: position, in: self.frame.size)
		case .drag:
			mGenerator.addDrag(point: position, in: self.frame.size)
		}
		self.requireDisplay()
	}

	public override func draw(_ dirtyRect: KCRect) {
		for gr in mGenerator.contents {
			switch gr {
			case .path(let path):
				let bezier = KCBezierPath(rect: self.bounds)
				bezier.lineJoinStyle = .round
				bezier.lineCapStyle  = .round
				bezier.lineWidth     = path.width
				let points = path.points(inRect: self.bounds)
				if points.count >= 2 {
					bezier.move(to: points[0])
					for i in 1..<points.count {
						bezier.addLine(to: points[i])
					}
				}
				bezier.stroke()
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
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
		vis.visit(vectorGraphics: self)
	}
}


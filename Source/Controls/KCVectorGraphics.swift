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

	public var currentType: CNVectorGraphicsType {
		get         { return mGenerator.currentType   }
		set(newval) { mGenerator.currentType = newval }
	}

	public var lineWidth: CGFloat {
		get	    { return mGenerator.lineWidth	}
		set(newval) { mGenerator.lineWidth = newval 	}
	}

	public var strokeColor: CNColor {
		get         { return mGenerator.strokeColor }
		set(newval) { mGenerator.strokeColor = newval }
	}

	public var fillColor: CNColor {
		get         { return mGenerator.fillColor }
		set(newval) { mGenerator.fillColor = newval }
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
				drawPath(vectorPath: path)
			case .rect(let rect):
				drawRect(vectorRect: rect)
			case .string(let str):
				drawString(vectorString: str)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
	}

	#if os(OSX)
	public override var acceptsFirstResponder: Bool {
		get { return true}
	}

	public override func keyDown(with event: NSEvent) {
		if let key = event.characters {
			NSLog("keydown (1): \(key)")
		}
	}
	#endif

	private func drawPath(vectorPath path: CNVectorPath){
		let points = path.normalize(in: self.frame.size)
		if points.count >= 2 {
			let bezier = KCBezierPath()
			bezier.lineJoinStyle = .round
			bezier.lineCapStyle  = .round

			let dofill = path.doFill
			bezier.lineWidth = path.lineWidth
			setPathColor(vectorObject: path, doFill: dofill)

			bezier.move(to: points[0])
			for i in 1..<points.count {
				bezier.addLine(to: points[i])
			}

			drawBezierPath(bezierPath: bezier, doFill: dofill)
		}
	}

	private func drawRect(vectorRect rect: CNVectorRect){
		if let normrect = rect.normalize(in: self.frame.size) {
			let bezier = KCBezierPath()
			bezier.lineJoinStyle = .round
			bezier.lineCapStyle  = .round

			let dofill = rect.doFill
			bezier.lineWidth = rect.lineWidth
			if rect.isRounded {
				bezier.appendRoundedRect(normrect, xRadius: 10.0, yRadius: 10.0)
			} else {
				bezier.appendRect(normrect)
			}
			setPathColor(vectorObject: rect, doFill: dofill)
			drawBezierPath(bezierPath: bezier, doFill: dofill)
		}
	}

	private func drawString(vectorString str: CNVectorString){
		if let orgpt = str.normalize(in: self.frame.size) {
			let astr  = str.string
			let asize = astr.size()
			let arect = CGRect(origin: orgpt, size: asize)

			/* Draw enter field */
			let outrect = KCRect.outsideRect(rect: arect, spacing: 2.0)
			let bezier  = KCBezierPath()
			bezier.lineWidth = 2.0
			bezier.setLineDash([2.0, 2.0], count: 2, phase: 0.0)
			bezier.appendRect(outrect)
			bezier.stroke()

			/* Draw string */
			if !str.isEmpty {
				astr.draw(at: orgpt)
			}
		}
	}

	private func drawBezierPath(bezierPath path: KCBezierPath, doFill fill: Bool){
		if fill {
			path.fill()
		} else {
			path.stroke()
		}
	}

	private func setPathColor(vectorObject vobj: CNVectorObject, doFill fill: Bool) {
		if fill {
			if !vobj.fillColor.isClear {
				vobj.fillColor.setFill()
			}
		} else {
			if !vobj.strokeColor.isClear {
				vobj.strokeColor.setStroke()
			}
		}
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


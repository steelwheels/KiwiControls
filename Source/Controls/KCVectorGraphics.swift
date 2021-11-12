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
			let bezier = KCBezierPath()
			bezier.lineJoinStyle = .round
			bezier.lineCapStyle  = .round
			switch gr {
			case .path(let path):
				let dofill = path.doFill
				bezier.lineWidth = path.lineWidth
				setPathColor(vectorObject: path, doFill: dofill)
				let points = path.normalize(in: self.frame.size)
				if points.count >= 2 {
					bezier.move(to: points[0])
					for i in 1..<points.count {
						bezier.addLine(to: points[i])
						NSLog("addLine: \(points[i].description) \(self.frame.description) \(self.bounds.description)")
					}
				}
				drawPath(bezierPath: bezier, doFill: dofill)
			case .rect(let rect):
				if let normrect = rect.normalize(in: self.frame.size) {
					let dofill = rect.doFill
					bezier.lineWidth = rect.lineWidth
					if rect.isRounded {
						bezier.appendRoundedRect(normrect, xRadius: 10.0, yRadius: 10.0)
					} else {
						bezier.appendRect(normrect)
					}
					setPathColor(vectorObject: rect, doFill: dofill)
					drawPath(bezierPath: bezier, doFill: dofill)
				}
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
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

	private func drawPath(bezierPath path: KCBezierPath, doFill fill: Bool){
		if fill {
			path.fill()
		} else {
			path.stroke()
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


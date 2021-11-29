/*
 * @file	KCVectorObject.swift
 * @brief	Define KCVectorObject class
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

private func normalizePoint(source src: CGPoint, in area: CGSize) -> CGPoint {
	let x = area.width  * src.x
	let y = area.height * src.y
	return CGPoint(x: x, y: y)
}

private func centerPoint(points pts: Array<CGPoint>) -> CGPoint {
	var minx = pts[0].x ; var maxx = minx
	var miny = pts[0].y ; var maxy = miny
	for i in 1..<pts.count {
		minx = min(minx, pts[i].x)
		maxx = max(maxx, pts[i].x)
		miny = min(miny, pts[i].y)
		maxy = max(maxy, pts[i].y)
	}
	return CGPoint(x: (minx + maxx) / 2.0, y: (miny + maxy) / 2.0)
}

public extension CNGripPoint
{
	func allocate(position pos: CNPosition, centerPoint center: CGPoint, radius rad: CGFloat) {
		let bezier = CNBezierPath()
		#if os(OSX)
			let bounds = CGRect(x: center.x - rad, y: center.y - rad, width: rad * 2.0, height: rad * 2.0)
			bezier.appendOval(in: bounds)
		#else
			bezier.appendOval(center: center, radius: rad)
		#endif
		self.setBezierPath(bezierPath: bezier)
		self.setPosition(position: pos)
	}

	func draw(){
		if let bezier = self.bezierPath {
			bezier.stroke()
		}
	}
}

public extension CNVectorObject
{
	func allocateGripPoint(position pos: CNPosition, point pt: CGPoint){
		let grip = self.allocateGripPoint()
		grip.allocate(position: pos, centerPoint: pt, radius: 3.0)
	}

	func drawGripPoints(){
		for grip in self.gripPoints {
			grip.draw()
		}
	}
}

public extension CNPathObject
{
	func allocateBezierPath() -> CNBezierPath {
		let newpath = CNBezierPath()
		newpath.lineWidth	= self.lineWidth
		newpath.lineCapStyle	= .round
		newpath.lineJoinStyle	= .round
		setBezierPath(bezierPath: newpath)
		return newpath
	}

	func draw(){
		if let path = self.bezierPath {
			if self.doFill {
				path.fill()
			} else {
				path.stroke()
			}
		} else {
			CNLog(logLevel: .error, message: "No bezier path", atFunction: #function, inFile: #file)
		}
	}
}

public extension CNVectorPath
{
	func allocate(in area: CGSize) {
		let points = self.normalize(in: area)
		if points.count > 0 {
			/* Draw path */
			let bezier = allocateBezierPath()
			bezier.move(to: points[0])
			for i in 1..<points.count {
				bezier.addLine(to: points[i])
			}
			/* Allocate center grab point */
			clearGripPoints()
			if let lastpt = points.last {
				let pos = CNPosition(horizontal: .center, vertical: .middle)
				allocateGripPoint(position: pos, point: lastpt)
			}
		}
	}
}

public extension CNVectorRect
{
	func allocate(in area: CGSize) {
		if let normrect = self.normalize(in: area) {
			/* Allocate rect */
			let bezier = allocateBezierPath()
			if self.isRounded {
				bezier.appendRoundedRect(normrect, xRadius: 10.0, yRadius: 10.0)
			} else {
				bezier.appendRect(normrect)
			}
			/* Allocate grip points */
			clearGripPoints()
			allocateGripPoint(position: CNPosition(horizontal: .left, vertical: .top),
					  point: normrect.upperLeftPoint)
			allocateGripPoint(position: CNPosition(horizontal: .center, vertical: .top),
					  point: CGPoint.center(normrect.upperLeftPoint, normrect.upperRightPoint))
			allocateGripPoint(position: CNPosition(horizontal: .right, vertical: .top),
					  point: normrect.upperRightPoint)

			allocateGripPoint(position: CNPosition(horizontal: .left, vertical: .middle),
					  point: CGPoint.center(normrect.upperLeftPoint, normrect.lowerLeftPoint))
			allocateGripPoint(position: CNPosition(horizontal: .right, vertical: .middle),
					  point: CGPoint.center(normrect.upperRightPoint, normrect.lowerRightPoint))

			allocateGripPoint(position: CNPosition(horizontal: .left, vertical: .bottom),
					  point: normrect.lowerLeftPoint)
			allocateGripPoint(position: CNPosition(horizontal: .center, vertical: .bottom),
					  point: CGPoint.center(normrect.lowerLeftPoint, normrect.lowerRightPoint))
			allocateGripPoint(position: CNPosition(horizontal: .right, vertical: .bottom),
					  point: normrect.lowerRightPoint)
		}
	}
}

public extension CNVectorOval
{
	func allocate(in area: CGSize) {
		if let (center, radius) = self.normalize(in: area) {
			/* Allocate oval */
			let bezier = allocateBezierPath()
			#if os(OSX)
				let bounds = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2.0, height: radius * 2.0)
				bezier.appendOval(in: bounds)
			#else
				bezier.appendOval(center: center, radius: radius)
			#endif

			/* Allocate upper-center grab point */
			clearGripPoints()
			let oval = CNOval(center: center, radius: radius)
			allocateGripPoint(position: CNPosition(horizontal: .center, vertical: .top),
					  point: oval.upperCenter)
			allocateGripPoint(position: CNPosition(horizontal: .left, vertical: .middle),
					  point: oval.middleLeft)
			allocateGripPoint(position: CNPosition(horizontal: .right, vertical: .middle),
					  point: oval.middleRight)
			allocateGripPoint(position: CNPosition(horizontal: .center, vertical: .bottom),
					  point: oval.lowerCenter)
		}
	}
}

public extension CNVectorString
{
	func draw(textField textfield: KCTextEdit, isEdtiable isedit: Bool, in area: CGSize) {
		if let orgpt = self.normalize(in: area) {
			if isedit {
				/* Show text edit */
				textfield.font = self.font
				CNVectorString.updateTextFieldLocation(textField: textfield, offset: orgpt)
				textfield.isHidden = false
				textfield.requireLayout()
				/* Update frame size */
				self.frame = CGRect.zero
			} else {
				textfield.isHidden = true
				let astr = self.attributedString()
				astr.draw(at: orgpt)
				self.frame = CGRect(origin: orgpt, size: astr.size())
			}
		}
	}

	static func updateTextFieldLocation(textField field: KCTextEdit, offset ofst: CGPoint){
		let size   = field.intrinsicContentSize
		let frame  = CGRect(origin: ofst, size: size)
		let bounds = CGRect(origin: CGPoint.zero, size: size)
		field.frame  = frame
		field.bounds = bounds
	}
}


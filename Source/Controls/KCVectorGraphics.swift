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
	private var mTextField:		KCTextEdit

	public override init(frame: KCRect) {
		mGenerator  = CNVecroGraphicsGenerator()
		mWidth	    = nil
		mHeight	    = nil
		mTextField  = KCTextEdit()
		super.init(frame: frame)
		self.setup()
	}

	required public init?(coder: NSCoder) {
		mGenerator  = CNVecroGraphicsGenerator()
		mWidth	    = nil
		mHeight	    = nil
		mTextField  = KCTextEdit()
		super.init(coder: coder)
		self.setup()
	}

	private func setup(){
		/* Setup text field */
		self.addSubview(mTextField)
		mTextField.text       = ""
		mTextField.format     = .label
		mTextField.isEditable = true
		mTextField.isBezeled  = true
		mTextField.isHidden   = true
		mTextField.callbackFunction = {
			(_ str: String) -> Void in
			self.mGenerator.storeString(string: str)
		}
		updateTextFieldLocation(textField: mTextField, offset: CGPoint.zero)
	}

	private func updateTextFieldLocation(textField field: KCTextEdit, offset ofst: CGPoint){
		let size   = field.intrinsicContentSize
		let frame  = CGRect(origin: ofst, size: size)
		let bounds = CGRect(origin: CGPoint.zero, size: size)
		field.frame  = frame
		field.bounds = bounds
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
			if let str = mGenerator.loadString() {
				mTextField.text = str
			}
		case .up:
			mGenerator.addUp(point: position, in: self.frame.size)
		case .drag:
			mGenerator.addDrag(point: position, in: self.frame.size)
		}
		self.requireDisplay()
	}

	public override func draw(_ dirtyRect: KCRect) {
		let contents = mGenerator.contents
		let count    = contents.count
		for i in 0..<count {
			let gr = contents[i]
			switch gr {
			case .path(let path):
				drawPath(vectorPath: path)
			case .rect(let rect):
				drawRect(vectorRect: rect)
			case .oval(let oval):
				drawOval(vectorOval: oval)
			case .string(let str):
				drawString(vectorString: str, isLast: (i == count-1))
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
		super.draw(dirtyRect)
	}

	private func drawPath(vectorPath path: CNVectorPath){
		let points = path.normalize(in: self.frame.size)
		if points.count >= 2 {
			let bezier = allocateBezierPath()
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
			let bezier = allocateBezierPath()
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

	private func drawOval(vectorOval oval: CNVectorOval){
		if let (center, radius) = oval.normalize(in: self.frame.size) {
			let bezier = allocateBezierPath()
			let dofill = oval.doFill
			bezier.lineWidth = oval.lineWidth
			#if os(OSX)
				let bounds = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2.0, height: radius * 2.0)
				bezier.appendOval(in: bounds)
			#else
				bezier.appendOval(center: center, radius: radius)
			#endif
			setPathColor(vectorObject: oval, doFill: dofill)
			drawBezierPath(bezierPath: bezier, doFill: dofill)
		}
	}

	private func drawString(vectorString str: CNVectorString, isLast islast: Bool){
		if let orgpt = str.normalize(in: self.frame.size) {
			if islast {
				/* Show text edit */
				mTextField.font = str.font
				updateTextFieldLocation(textField: mTextField, offset: orgpt)
				mTextField.isHidden = false
				mTextField.requireLayout()
			} else {
				mTextField.isHidden = true
				/* Draw text */
				let attrs: [NSAttributedString.Key: Any] = [
					NSAttributedString.Key.foregroundColor: str.strokeColor,
					NSAttributedString.Key.backgroundColor:	CNColor.clear,
					NSAttributedString.Key.font:		str.font
				]
				let astr = NSAttributedString(string: str.string, attributes: attrs)
				astr.draw(at: orgpt)
			}
		}
	}

	private func allocateBezierPath() -> KCBezierPath {
		let bezier = KCBezierPath()
		bezier.lineJoinStyle = .round
		bezier.lineCapStyle  = .round
		return bezier
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


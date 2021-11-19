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

public extension CNVectorObject
{
	func draw(bezierPath path: CNBezierPath){
		if self.doFill {
			path.fill()
		} else {
			path.stroke()
		}
	}
}

public extension CNVectorPath
{
	func draw(in area: CGSize) {
		let points = self.normalize(in: area)
		if points.count >= 2 {
			let bezier = allocateBezierPath()
			bezier.move(to: points[0])
			for i in 1..<points.count {
				bezier.addLine(to: points[i])
			}
			super.draw(bezierPath: bezier)
		}
	}
}

public extension CNVectorRect
{
	func draw(in area: CGSize) {
		if let normrect = self.normalize(in: area) {
			let bezier = allocateBezierPath()
			if self.isRounded {
				bezier.appendRoundedRect(normrect, xRadius: 10.0, yRadius: 10.0)
			} else {
				bezier.appendRect(normrect)
			}
			super.draw(bezierPath: bezier)
		}
	}
}

public extension CNVectorOval
{
	func draw(in area: CGSize) {
		if let (center, radius) = self.normalize(in: area) {
			let bezier = allocateBezierPath()
			#if os(OSX)
				let bounds = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2.0, height: radius * 2.0)
				bezier.appendOval(in: bounds)
			#else
				bezier.appendOval(center: center, radius: radius)
			#endif
			super.draw(bezierPath: bezier)
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
			} else {
				textfield.isHidden = true
				let astr = self.attributedString()
				astr.draw(at: orgpt)
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
		CNVectorString.updateTextFieldLocation(textField: mTextField, offset: CGPoint.zero)
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
				path.draw(in: self.frame.size)
			case .rect(let rect):
				rect.draw(in: self.frame.size)
			case .oval(let oval):
				oval.draw(in: self.frame.size)
			case .string(let str):
				str.draw(textField: mTextField, isEdtiable: i == count - 1, in: self.frame.size)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
		super.draw(dirtyRect)
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


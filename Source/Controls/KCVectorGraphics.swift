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

public enum KCVectorToolType
{
	case mover			// ()
	case path(Bool)			// (doFill)
	case rect(Bool, Bool)		// (doFill, isRounded)
	case oval(Bool)			// (doFill)
	case string			// (font)

	public func toGraphicsType() -> CNVectorGraphicsType? {
		let result: CNVectorGraphicsType?
		switch self {
		case .mover:				result = nil
		case .path(let dofill):			result = .path(dofill)
		case .rect(let dofill, let isround):	result = .rect(dofill, isround)
		case .oval(let dofill):			result = .oval(dofill)
		case .string:				result = .string
		}
		return result
	}

	public var description: String { get {
		let result: String
		switch self {
		case .mover:
			result = "mover"
		case .path(let dofill):
			result = "path(doFill:\(dofill))"
		case .rect(let dofill, let isrounded):
			result = "rect(doFill:\(dofill), isRounded:\(isrounded))"
		case .oval(let dofill):
			result = "oval(doFill:\(dofill))"
		case .string:
			result = "string"
		}
		return result
	}}
}

open class KCVectorGraphics: KCView
{
	private var mManager:		CNVectorManager
	private var mWidth:		CGFloat?
	private var mHeight:		CGFloat?
	private var mToolType:		KCVectorToolType
	private var mTextField:		KCTextEdit

	public override init(frame: CGRect) {
		mManager    		= CNVectorManager()
		mWidth	    		= nil
		mHeight	   		= nil
		mToolType		= .mover
		mTextField  		= KCTextEdit()
		super.init(frame: frame)
		self.setup()
	}

	required public init?(coder: NSCoder) {
		mManager    		= CNVectorManager()
		mWidth	    		= nil
		mHeight	    		= nil
		mToolType		= .mover
		mTextField  		= KCTextEdit()
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
			self.mManager.storeString(string: str)
		}
		CNVectorString.updateTextFieldLocation(textField: mTextField, offset: CGPoint.zero)

		#if os(OSX)
			//setDroppableClass(droppableClass: NSString.self)
		#endif
	}

	public var toolType: KCVectorToolType {
		get          { return mToolType }
		set(newtype) { mToolType = newtype }
	}

	public var lineWidth: CGFloat {
		get	    { return mManager.lineWidth	}
		set(newval) { mManager.lineWidth = newval 	}
	}

	public var strokeColor: CNColor {
		get         { return mManager.strokeColor }
		set(newval) { mManager.strokeColor = newval }
	}

	public var fillColor: CNColor {
		get         { return mManager.fillColor }
		set(newval) { mManager.fillColor = newval }
	}

	public var width: CGFloat? {
		get         { return mWidth    }
		set(newval) { mWidth = newval  }
	}

	public var height: CGFloat? {
		get         { return mHeight   }
		set(newval) { mHeight = newval }
	}

	private enum DrawEvent {
		case drawPath(CNVectorGraphics)
		case moveObject(CGPoint, CNVectorGraphics)
		case changeSize(CGPoint, CNGripPoint, CNVectorGraphics)
	}

	private var mDrawEvent: DrawEvent? = nil

	public override func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		switch event {
		case .down:
			switch mManager.contains(point: position) {
			case .none:
				if let gtype = mToolType.toGraphicsType() {
					let newobj = mManager.addObject(location: position, type: gtype)
					switch newobj {
					case .path(_):
						mDrawEvent = .drawPath(newobj)
					case .rect(_), .oval(_), .string(_):
						mDrawEvent = .moveObject(position, newobj)
					@unknown default:
						CNLog(logLevel: .error, message: "Unexpected case", atFunction: #function, inFile: #file)
						mDrawEvent = nil
					}
				} else {
					mDrawEvent = nil
				}
			case .selectCurrentGrip(let grip, let obj):
				mDrawEvent = .changeSize(position, grip, obj)
			case .selectCurrentObject(let obj):
				mDrawEvent = .moveObject(position, obj)
			case .selectOtherObject(let idx):
				mManager.selectObject(index: idx)
				mDrawEvent = nil
			@unknown default:
				CNLog(logLevel: .error, message: "Unexpected case", atFunction: #function, inFile: #file)
				mDrawEvent = nil
			}
		case .drag, .up:
			if let devent = mDrawEvent {
				switch devent {
				case .drawPath(let obj):
					addPointToObjectEvent(nextPosition: position, graphics: obj)
					mDrawEvent = .drawPath(obj)
				case .moveObject(let curpos, let obj):
					moveObjectEvent(originalPosition: curpos, object: obj, newPosition: position)
					mDrawEvent = .moveObject(position, obj)
				case .changeSize(let curpos, let grip, let obj):
					changeSizeEvent(originalPosition: curpos, gripPoint: grip, object: obj, newPosition: position)
					mDrawEvent = .changeSize(position, grip, obj)
				}
			}
		}
		self.requireDisplay()
	}

	private func changeSizeEvent(originalPosition orgpos: CGPoint, gripPoint grip: CNGripPoint, object obj: CNVectorGraphics, newPosition newpos: CGPoint){
		mManager.reshapeObject(nextPoint: newpos, grip: grip, object: obj)
	}

	private func moveObjectEvent(originalPosition orgpos: CGPoint, object obj: CNVectorGraphics, newPosition newpos: CGPoint){
		let diffpos = newpos.subtracting(orgpos)
		mManager.moveObject(diffPoint: diffpos, object: obj)
	}

	private func addPointToObjectEvent(nextPosition nxtpos: CGPoint, graphics obj: CNVectorGraphics){
		mManager.addPointToObject(nextPoint: nxtpos, object: obj)
	}

	public override func draw(_ dirtyRect: CGRect) {
		let selgr: Bool
		switch mToolType {
		case .mover:
			selgr = false
		case .path(_), .rect(_, _), .oval(_), .string:
			selgr = true
		}

		let contents = mManager.contents
		let count    = contents.count
		for i in 0..<count {
			let gr = contents[i]
			switch gr {
			case .path(let path):
				path.setColors()
				path.allocate(in: self.frame.size)
				path.draw()
			case .rect(let rect):
				rect.setColors()
				rect.allocate(in: self.frame.size)
				rect.draw()
			case .oval(let oval):
				oval.setColors()
				oval.allocate(in: self.frame.size)
				oval.draw()
			case .string(let str):
				str.setColors()
				str.draw(textField: mTextField, isEdtiable: selgr && (i == count - 1))
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
		if selgr {
			if let obj = mManager.currentObject() {
				CNGripPoint.setColors()
				switch obj {
				case .path(let path):	path.drawGripPoints()
				case .rect(let rect):	rect.drawGripPoints()
				case .oval(let oval):	oval.drawGripPoints()
				case .string(let vstr):	vstr.drawGripPoints()
				@unknown default:
					CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				}
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

	public override var intrinsicContentSize: CGSize {
		get {
			let ssize  = super.intrinsicContentSize
			let width  = mWidth  ?? ssize.width
			let height = mHeight ?? ssize.height
			return CGSize(width: width, height: height)
		}
	}

	/*
	 * drop operation
	 *   reference: https://qiita.com/IKEH/items/1cdf51591be506c3f74b
	 */
	#if false // os(OSX)
	open override func receiveDroppedObjects(_ sender: NSDraggingInfo, droppedObjects objs: Array<AnyObject>) -> Bool {
		var result = false
		if let strs = objs as? Array<NSString> {
			let str = strs[0] as String
			if let gtype = decodeGraphicsType(string: str) {
				let orgpos = sender.draggingLocation
				let locpos = orgpos - self.frame.origin
				mManager.addObject(location: locpos, in: self.frame.size, type: gtype)
				self.requireDisplay()
				result = true
			}
		}
		return result
	}

	private func decodeGraphicsType(string str: String) -> CNVectorGraphicsType? {
		var result: CNVectorGraphicsType? = nil
		switch str {
		case "character-a":			result = .string
		case "pencil":				result = .path(false)
		case "pencil-circle":			result = .path(true)
		case "rectangle":			result = .rect(false, false)
		case "rectangle-filled":		result = .rect(true, false)
		case "rectangle-rounded":		result = .rect(false, true)
		case "rectangle-filled-rounded":	result = .rect(true, true)
		case "oval":				result = .oval(false)
		case "oval-filled":			result = .oval(true)
		default:
			NSLog("Unknown graphics type: \(str)")
			result = .path(false)
		}
		return result
	}
	#endif

	/*
	 * load/store
	 */
	public func toValue() -> Dictionary<String, CNValue> {
		return mManager.toValue()
	}

	public func store(URL url: URL) -> Bool {
		return mManager.store(URL: url)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(vectorGraphics: self)
	}
}


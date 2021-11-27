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
	private var mManager:		CNVecroManager
	private var mWidth:		CGFloat?
	private var mHeight:		CGFloat?
	private var mTextField:		KCTextEdit

	public override init(frame: CGRect) {
		mManager    	= CNVecroManager()
		mWidth	    	= nil
		mHeight	   	= nil
		mTextField  	= KCTextEdit()
		super.init(frame: frame)
		self.setup()
	}

	required public init?(coder: NSCoder) {
		mManager    	= CNVecroManager()
		mWidth	    	= nil
		mHeight	    	= nil
		mTextField  	= KCTextEdit()
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
			self.registerForDraggedTypes(accessableTypes)
		#endif
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
		case changeShape(CGPoint, CNGripPoint, CNVectorGraphics)
		case moveObject(CGPoint, CNVectorGraphics)
	}

	private var mDrawEvent: DrawEvent? = nil

	public override func acceptMouseEvent(mouseEvent event:KCMouseEvent, mousePosition position:CGPoint){
		switch event {
		case .down:
			switch mManager.contains(point: position, in: self.frame.size) {
			case .none:
				mDrawEvent = nil
			case .grip(let grip, let obj):
				mDrawEvent = .changeShape(position, grip, obj)
			case .graphics(let obj):
				mDrawEvent = .moveObject(position, obj)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
				mDrawEvent = nil
			}
		case .drag, .up:
			if let mevent = mDrawEvent {
				switch mevent {
				case .changeShape(let curpos, let grip, let obj):
					changeSizeEvent(originalPosition: curpos, gripPoint: grip, graphics: obj, newPosition: position)
					/* Update latest position */
					mDrawEvent = .changeShape(position, grip, obj)
				case .moveObject(let curpos, let obj):
					moveObjectEvent(originalPosition: curpos, graphics: obj, newPosition: position)
					/* Update latest position */
					mDrawEvent = .moveObject(position, obj)
				}
				self.requireDisplay()
			}
		}
	}

	private func changeSizeEvent(originalPosition orgpos: CGPoint, gripPoint grip: CNGripPoint, graphics obj: CNVectorGraphics, newPosition newpos: CGPoint){
		NSLog("changeSizeEvent: \(orgpos.description) -> \(newpos.description)")
	}

	private func moveObjectEvent(originalPosition orgpos: CGPoint, graphics obj: CNVectorGraphics, newPosition newpos: CGPoint){
		let diffpos = newpos - orgpos
		mManager.moveItem(diffPoint: diffpos, in: self.frame.size, graphics: obj)
	}

	public override func draw(_ dirtyRect: CGRect) {
		let contents = mManager.contents
		let count    = contents.count
		for i in 0..<count {
			let gr = contents[i]
			switch gr {
			case .path(let path):
				path.allocate(in: self.frame.size)
				path.draw()
			case .rect(let rect):
				rect.allocate(in: self.frame.size)
				rect.draw()
			case .oval(let oval):
				oval.allocate(in: self.frame.size)
				oval.draw()
			case .string(let str):
				str.draw(textField: mTextField, isEdtiable: i == count - 1, in: self.frame.size)
			@unknown default:
				CNLog(logLevel: .error, message: "Unknown case", atFunction: #function, inFile: #file)
			}
		}
		if let item = mManager.currentItem() {
			switch item {
			case .path(let obj):
				obj.drawGripPoints()
			case .rect(let obj):
				obj.drawGripPoints()
			case .oval(let obj):
				obj.drawGripPoints()
			case .string(let obj):
				obj.drawGripPoints()
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

	public override var intrinsicContentSize: CGSize {
		get {
			let ssize  = super.intrinsicContentSize
			let width  = mWidth  != nil ? mWidth!  : ssize.width
			let height = mHeight != nil ? mHeight! : ssize.height
			return CGSize(width: width, height: height)
		}
	}

	/*
	 * drop operation
	 *   reference: https://qiita.com/IKEH/items/1cdf51591be506c3f74b
	 */
	#if os(OSX)
	private let accessableTypes: Array<NSPasteboard.PasteboardType> = [.string, .pdf, .png, .tiff]
	private let draggableTypes: Dictionary<NSPasteboard.ReadingOptionKey, Any>? = [
		.urlReadingContentsConformToTypes : NSImage.imageTypes
	]

	public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		if canReadObject(sender) {
			return .link
		} else {
			return super.draggingEntered(sender)
		}
	}

	public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
		var result = false
		if canReadObject(sender) {
			let pboard = sender.draggingPasteboard
			if let strs = pboard.readObjects(forClasses: [NSString.self], options: draggableTypes) as? Array<NSString> {
				let str = strs[0] as String
				if let gtype = decodeGraphicsType(string: str) {
					let orgpos = sender.draggingLocation
					let locpos = orgpos - self.frame.origin
					mManager.addItem(location: locpos, in: self.frame.size, graphicsType: gtype)
					self.requireDisplay()
					result = true
				}
			}
		}
		return result
	}

	public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		NSLog("performDragOperation")
		return true
	}

	private func canReadObject(_ sender: NSDraggingInfo) -> Bool {
		let pboard = sender.draggingPasteboard
		return pboard.canReadObject(forClasses: [NSString.self], options: [:])
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

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(vectorGraphics: self)
	}
}


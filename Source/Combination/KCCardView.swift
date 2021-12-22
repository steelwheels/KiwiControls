/**
 * @file KCCardView.swift
 * @brief Define KCCardView class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCCardView: KCStackView
{
	private var mCurrentIndex:	Int

	#if os(OSX)
	public override init(frame : NSRect){
		mCurrentIndex	= 0
		super.init(frame: frame) ;
	}
	#else
	public override init(frame: CGRect){
		mCurrentIndex	= 0
		super.init(frame: frame)
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 346)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		mCurrentIndex	= 0
		super.init(coder: coder)
	}

	public var currentIndex: Int {
		get         { return mCurrentIndex   }
	}

	open func setIndex(index idx: Int) -> Bool {
		if 0 <= idx {
			mCurrentIndex = idx
			return true
		} else {
			return false
		}
	}

	#if os(OSX)
	public override var acceptsFirstResponder: Bool {
		get { return true }
	}
	#endif

	public var firstResponderView: KCViewBase? { get {
		return self
	}}

	open override func acceptKeyEvent(keyUp up: Bool, keyCategory cat: CNKeyCategory) -> Bool {
		var result: Bool = false
		switch cat {
		case .alphabet(_), .digit(_), .function(_), .symbol(_), .space(_):
			break
		case .special(let key):
			switch key {
			case .leftArrow:
				//NSLog("Left arrow pressed")
				result = setIndex(index: mCurrentIndex - 1)
			case .rightArrow:
				//NSLog("Right arrow pressed")
				result = setIndex(index: mCurrentIndex + 1)
			default:
				break
			}
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown key code", atFunction: #function, inFile: #file)
		}
		return result
	}
}


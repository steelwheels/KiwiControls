/**
 * @file KCRadioButtons.swift
 * @brief Define KCRadioButtons class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCRadioButtons: KCStackView
{
	public typealias CallbackFunction = KCRadioButtonCore.CallbackFunction

	private var mLabels:		Array<String>
	private var mButtons:		Array<KCRadioButton>
	private var mCurrentIndex:	Int?
	private var mColumunNum:	Int
	private var mCallbackFunction:	CallbackFunction?

	#if os(OSX)
	public override init(frame : NSRect){
		mLabels     		= []
		mButtons		= []
		mCurrentIndex		= nil
		mColumunNum 		= 1
		mCallbackFunction	= nil
		super.init(frame: frame) ;
	}
	#else
	public override init(frame: CGRect){
		mLabels     		= []
		mButtons		= []
		mCurrentIndex		= nil
		mColumunNum 		= 1
		mCallbackFunction	= nil
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
		mLabels     		= []
		mButtons		= []
		mCurrentIndex		= nil
		mColumunNum 		= 1
		mCallbackFunction	= nil
		super.init(coder: coder)
	}

	public var currentIndex: Int? {
		get { return mCurrentIndex }
	}

	public var numberOfColumns: Int {
		get         { return mColumunNum }
		set(newval) {
			if newval >= 1 {
				mColumunNum = newval
			} else {
				CNLog(logLevel: .error, message: "Invalid numberOfColumns: \(newval)", atFunction: #function, inFile: #file)
			}
		}
	}

	public var callback: CallbackFunction? {
		get         { return self.mCallbackFunction }
		set(newval) { self.mCallbackFunction = newval }
	}

	public func setLabels(labels labs: Array<String>){
		guard labs.count >= 1 else {
			CNLog(logLevel: .error, message: "Invalid label num", atFunction: #function, inFile: #file)
			return
		}
		mLabels		= labs

		/* Clear subview */
		super.removeAllArrangedSubviews()
		mButtons = []

		let cbfunc: KCRadioButton.CallbackFunction = {
			(_ index: Int) -> Void in self.select(index: index)
		}

		/* Allocate boxes to arrange some radio buttons */
		let labelnum = labs.count
		let rownum   = (labelnum + mColumunNum - 1) / mColumunNum
		var buttonid = 0
		for _ in 0..<rownum {
			let hbox  = KCStackView()
			hbox.axis = .horizontal
			for _ in 0..<mColumunNum {
				if buttonid < labelnum {
					let newbutton = KCRadioButton()
					newbutton.buttonId = buttonid
					newbutton.title    = labs[buttonid]
					newbutton.callback = cbfunc
					buttonid += 1
					hbox.addArrangedSubView(subView: newbutton)
					mButtons.append(newbutton)
				}
			}
			super.addArrangedSubView(subView: hbox)
		}

		/* Activate 1 button */
		for i in 0..<mButtons.count {
			let button = mButtons[i]
			if button.isEnabled && button.isVisible {
				button.state = true
				mCurrentIndex = i
				break
			}
		}
	}

	public func select(index newidx: Int){
		guard 0<=newidx && newidx<mButtons.count else {
			CNLog(logLevel: .error, message: "Invalid index: \(newidx)", atFunction: #function, inFile: #file)
			return // invalid range
		}
		guard mButtons[newidx].isEnabled && mButtons[newidx].isVisible else {
			return // can not select new one
		}
		if let curidx = mCurrentIndex {
			if curidx == newidx {
				return // current index == new index
			} else {
				mButtons[curidx].state = false
			}
		}
		mButtons[newidx].state = true
		mCurrentIndex = newidx
		/* Callback */
		if let cbfunc = mCallbackFunction {
			cbfunc(newidx)
		}
	}

	public func setEnable(enables enb: Array<CNValue>) {
		let fnum = min(mButtons.count, enb.count)
		for i in 0..<fnum {
			switch enb[i] {
			case .boolValue(let doenable):
				setEnable(index: i, enable: doenable)
			case .numberValue(let num):
				let doenable = num.boolValue || (num.intValue != 0)
				setEnable(index: i, enable: doenable)
			default:
				CNLog(logLevel: .error, message: "Unexpected parameter type", atFunction: #function, inFile: #file)
			}
		}
	}

	public func setEnable(index idx: Int, enable enb: Bool) {
		guard 0<=idx && idx<mButtons.count else {
			CNLog(logLevel: .error, message: "Invalid index: \(idx)", atFunction: #function, inFile: #file)
			return // invalid range
		}
		if let curidx = mCurrentIndex {
			if !enb && (curidx == idx) {
				/* Disable the current selected item */
				mButtons[curidx].state = false
				mCurrentIndex = nil
			}
		}
		mButtons[idx].isEnabled = enb
	}

}


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
	private var mActiveIndex:	Int?
	private var mColumunNum:	Int
	private var mCallbackFunction:	CallbackFunction?

	#if os(OSX)
	public override init(frame : NSRect){
		mLabels     		= []
		mButtons		= []
		mActiveIndex		= nil
		mColumunNum 		= 1
		mCallbackFunction	= nil
		super.init(frame: frame) ;
	}
	#else
	public override init(frame: CGRect){
		mLabels     		= []
		mButtons		= []
		mActiveIndex		= nil
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
		mActiveIndex		= nil
		mColumunNum 		= 1
		mCallbackFunction	= nil
		super.init(coder: coder)
	}

	public var callback: CallbackFunction? {
		get         { return self.mCallbackFunction }
		set(newval) { self.mCallbackFunction = newval }
	}

	public func setLabels(labels labs: Array<String>, columnNum cnum: Int){
		guard labs.count >= 1 else {
			CNLog(logLevel: .error, message: "Invalid label num", atFunction: #function, inFile: #file)
			return
		}
		guard cnum >= 1 else {
			CNLog(logLevel: .error, message: "Invalid column num", atFunction: #function, inFile: #file)
			return
		}
		mLabels		= labs
		mColumunNum	= cnum

		/* Clear subview */
		super.removeAllArrangedSubviews()
		mButtons = []

		let cbfunc: KCRadioButton.CallbackFunction = {
			(_ index: Int) -> Void in self.select(index: index)
		}

		/* Allocate boxes to arrange some radio buttons */
		let labelnum = labs.count
		let rownum   = (labelnum + cnum - 1) / cnum
		var buttonid = 0
		for _ in 0..<rownum {
			let hbox  = KCStackView()
			hbox.axis = .horizontal
			for _ in 0..<cnum {
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
				mActiveIndex = i
				break
			}
		}
	}

	public func select(index newidx: Int){
		guard 0<=newidx && newidx<mButtons.count else {
			return // invalid range
		}
		guard mButtons[newidx].isEnabled && mButtons[newidx].isVisible else {
			return // can not select new one
		}
		if let actidx = mActiveIndex {
			if actidx == newidx {
				return // current index == new index
			} else {
				// clear current button
				mButtons[actidx].state = false
			}
		}
		mButtons[newidx].state = true
		mActiveIndex = newidx
		/* Callback */
		if let cbfunc = mCallbackFunction {
			cbfunc(newidx)
		}
	}

}


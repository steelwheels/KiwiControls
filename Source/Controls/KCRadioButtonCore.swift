/**
 * @file	KCRadioButtonCore.swift
 * @brief	Define KCRadioButtonCore class
 * @par Copyright
 *   Copyright (C) 2022 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

open class KCRadioButtonCore: KCCoreView
{
	public typealias CallbackFunction = (_ buttonid: Int) -> Void

	private var mButtonID: Int? 			 = nil
	private var mState: CNButtonState		 = .hidden
	private var mCallbackFunction: CallbackFunction? = nil
	private var mMinLabelWidth: Int			 = 8

	#if os(OSX)
	@IBOutlet weak var mRadioButton: NSButton!
	#else
	@IBOutlet weak var mLabel: UILabel!
	@IBOutlet weak var mSwitch: UISwitch!
	#endif

	public func setup(frame frm: CGRect){
		#if os(OSX)
		super.setup(isSingleView: false, coreView: mRadioButton)
		#else
		super.setup(isSingleView: false, coreView: mSwitch)
		#endif
		self.state = .off
	}

	public var buttonId: Int? {
		get         { return mButtonID }
		set(newval) { mButtonID = newval }
	}

	public var title: String {
		get {
			#if os(OSX)
				return mRadioButton.title
			#else
				return mLabel.text ?? ""
			#endif
		}
		set(newval) {
			#if os(OSX)
				mRadioButton.title = newval
			#else
				mLabel.text = newval
			#endif
		}
	}

	public var state: CNButtonState {
		get {
			return mState
		}
		set(newstat) {
			if mState != newstat {
				switch newstat {
				case .hidden:
					self.isVisible	= false
					self.isEnabled	= false
					self.isOn	= false
				case .disable:
					self.isVisible	= true
					self.isEnabled	= false
					self.isOn	= false
				case .off:
					self.isVisible	= true
					self.isEnabled	= true
					self.isOn	= false
				case .on:
					self.isVisible	= true
					self.isEnabled	= true
					self.isOn	= true
				@unknown default:
					CNLog(logLevel: .error, message: "Internal error", atFunction: #function, inFile: #file)
				}
				mState = newstat
			}
		}
	}

	private var isVisible: Bool {
		get {
			#if os(OSX)
				return !mRadioButton.isHidden
			#else
				return !mSwitch.isHidden
			#endif
		}
		set(newval) {
			#if os(OSX)
				mRadioButton.isHidden = !newval
			#else
				mSwitch.isHidden = !newval
				mLabel.isHidden  = !newval
			#endif
		}
	}

	private var isEnabled: Bool {
		get         {
			#if os(OSX)
				return mRadioButton.isEnabled
			#else
				return mSwitch.isEnabled
			#endif
		}
		set(newval) {
			#if os(OSX)
				mRadioButton.isEnabled = newval
			#else
				mSwitch.isEnabled = newval
				mLabel.isEnabled = newval
			#endif
		}
	}

	private var isOn: Bool {
		get {
			#if os(OSX)
				return mRadioButton.state != .off
			#else
				return mSwitch.state == .selected
			#endif
		}
		set(newval){
			#if os(OSX)
				mRadioButton.state = newval ? .on : .off
			#else
				mSwitch.setOn(newval, animated: true)
			#endif
		}
	}

	public var callback: CallbackFunction? {
		get        { return mCallbackFunction }
		set(newval){ mCallbackFunction = newval }
	}

	public var minLabelWidth: Int {
		get         { return mMinLabelWidth }
		set(newval) { if newval >= 1 { mMinLabelWidth = newval }}
	}

	#if os(OSX)
	@IBAction func buttonPressed(_ sender: Any) {
		self.pressed()
	}
	#else
	@IBAction func buttonPressed(_ sender: Any) {
		self.pressed()
	}
	#endif

	private func pressed() {
		if let bid = mButtonID, let cbfunc = mCallbackFunction {
			cbfunc(bid)
		}
	}

	#if os(OSX)
	public override var fittingSize: CGSize {
		get { return CNMinSize(contentsSize(), self.limitSize) }
	}
	#else
	public override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CNMinSize(contentsSize(), self.limitSize)
	}
	#endif

	public override var intrinsicContentSize: CGSize {
		get { return CNMinSize(contentsSize(), self.limitSize) }
	}

	public override func contentsSize() -> CGSize {
		#if os(OSX)
			return mRadioButton.intrinsicContentSize
		#else
			let swsize  = mSwitch.intrinsicContentSize
			let labsize = mLabel.intrinsicContentSize
			let space   = CNPreference.shared.windowPreference.spacing
			return CNUnionSize(swsize, labsize, doVertical: false, spacing: space)
		#endif
	}

	public override func adjustContentsSize(size sz: CGSize) -> CGSize {
		let cursize = self.intrinsicContentSize
		if cursize.width <= sz.width && cursize.height <= sz.height {
			return sz
		} else {
			CNLog(logLevel: .error, message: "Size underflow", atFunction: #function, inFile: #file)
			return cursize
		}
	}
}


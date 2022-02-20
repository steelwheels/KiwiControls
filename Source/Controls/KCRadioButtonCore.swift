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
	public enum Status: Int {
		case disable
		case off
		case on

		public var description: String { get {
			let result: String
			switch self {
			case .disable:	result = "disable"
			case .off:	result = "off"
			case .on:	result = "on"
			}
			return result
		}}
	}

	public typealias CallbackFunction = (_ buttonid: Int, _ status: Status) -> Void

	private var mButtonID: Int? 			 = nil
	private var mCallbackFunction: CallbackFunction? = nil
	private var mMinLabelWidth: Int			 = 8

	#if os(OSX)
	@IBOutlet weak var mRadioButton: NSButton!
	#else
	@IBOutlet weak var mRadioButton: UIButton!
	#endif

	public func setup(frame frm: CGRect){
		super.setup(isSingleView: true, coreView: mRadioButton)
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
				return mRadioButton.title(for: .normal) ?? ""
			#endif
		}
		set(newval) {
			#if os(OSX)
				mRadioButton.title = newval
			#else
				mRadioButton.setTitle(newval, for: .normal)
				mRadioButton.setTitle(newval, for: .selected)
			#endif
		}
	}

	public var state: Bool {
		get {
			#if os(OSX)
				return mRadioButton.state != .off
			#else
				return mRadioButton.isHighlighted
			#endif
		}
		set(newval){
			#if os(OSX)
				mRadioButton.state = newval ? .on : .off
			#else
				mRadioButton.isHighlighted = newval
			#endif
		}
	}

	public var isEnabled: Bool {
		get         { return mRadioButton.isEnabled }
		set(newval) {
			if mRadioButton.isEnabled != newval {
				mRadioButton.isEnabled = newval
				if !newval {
					self.state = false
					if let bid = mButtonID, let cbfunc = mCallbackFunction {
						cbfunc(bid, self.status)
					}
				}
			}
		}
	}

	public var isVisible: Bool {
		get         { return !mRadioButton.isHidden }
		set(newval) { mRadioButton.isHidden = !newval }
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

	private var status: Status { get {
		let result: Status
		if self.isEnabled {
			if self.state {
				result = .on
			} else {
				result = .off
			}
		} else {
			result = .disable
		}
		return result
	}}

	private func pressed() {
		if let bid = mButtonID, let cbfunc = mCallbackFunction {
			cbfunc(bid, self.status)
		}
	}

	#if os(OSX)
	open override var fittingSize: CGSize {
		get { return contentSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return contentSize()
	}
	#endif

	open override var intrinsicContentSize: CGSize {
		get { return contentSize() }
	}

	private func contentSize() -> CGSize {
		#if os(OSX)
			var btnsize = mRadioButton.intrinsicContentSize
			if let font = mRadioButton.font {
				btnsize.width  = max(btnsize.width,  font.pointSize * CGFloat(mMinLabelWidth))
				btnsize.height = max(btnsize.height, font.pointSize * 1.2        )
			}
			let space = CNPreference.shared.windowPreference.spacing
			return CGSize(width:  btnsize.width + space, height: btnsize.height + space)
		#else
			return mRadioButton.intrinsicContentSize
		#endif
	}
}


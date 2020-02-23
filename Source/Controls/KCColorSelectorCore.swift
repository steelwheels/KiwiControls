/**
 * @file KCColorSelectorCore.swift
 * @brief Define KCColorSelectorCore class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData
import Foundation

open class KCColorSelectorCore: KCView
{
	public typealias CallbackFunction = (_ color: KCColor) -> Void

	private let ColorItem		= "color"
	private let defaultSize		= KCSize(width: 240, height: 48)

	#if os(OSX)
	@IBOutlet weak var mLabel: 	NSTextField!
	@IBOutlet weak var mColorWell: 	NSColorWell!
	#else
	@IBOutlet weak var mLabel: 	UILabel!
	@IBOutlet weak var mButton: 	UIButton!
	#endif

	public var callbackFunc	: CallbackFunction? = nil

	public func setup(frame frm: CGRect) -> Void {
		#if os(OSX)
			KCView.setAutolayoutMode(views: [self, mLabel, mColorWell])
		#else
			KCView.setAutolayoutMode(views: [self, mLabel, mButton])
		#endif
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		super.resize(bounds.size)
		connectObserver()
	}

	private func connectObserver() {
		#if os(OSX)
			mColorWell.addObserver(self, forKeyPath: ColorItem, options: [.new], context: nil)
		#endif
	}

	deinit {
		#if os(OSX)
			mColorWell.removeObserver(self, forKeyPath: ColorItem)
		#endif
	}

	public func setLabel(string str: String) {
		#if os(OSX)
			mLabel.stringValue = str
		#else
			mLabel.text = str
		#endif
	}

	#if os(OSX)
	public var color: KCColor {
		get {
			if let well = mColorWell {
				return well.color
			} else {
				NSLog("No color well for get")
				return KCColor.black
			}
		}
		set(newcol){
			if let well = mColorWell {
				well.color = newcol
			} else {
				NSLog("No color well for set")
			}
		}
	}
	#else
	public var color: KCColor {
		get {
			if let button = mButton {
				if let color = button.backgroundColor {
					return color
				}
			}
			NSLog("No color")
			return KCColor.black
		}
		set(newcol){
			if let button = mButton {
				button.backgroundColor = newcol
			}
		}
	}
	#endif

	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let key = keyPath {
			if key == ColorItem {
				if let cbfunc = self.callbackFunc  {
					#if os(OSX)
						cbfunc(mColorWell.color)
					#endif
				}
			}
		}
	}

	open override var fittingSize: KCSize {
		return defaultSize
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return defaultSize
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				return defaultSize
			}
		}
	}

	open override func resize(_ size: KCSize) {
		super.resize(size)
	}
}


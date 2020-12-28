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
	public typealias CallbackFunction = (_ color: CNColor) -> Void

	private let ColorItem		= "color"
	private let defaultSize		= KCSize(width: 64, height: 40)

	#if os(OSX)
	@IBOutlet weak var mColorWell: 	NSColorWell!
	#else
	@IBOutlet weak var mButton: 	UIButton!
	#endif

	public var callbackFunc	: CallbackFunction? = nil

	public func setup(frame frm: CGRect) -> Void {
		#if os(OSX)
			KCView.setAutolayoutMode(views: [self, mColorWell])
		#else
			KCView.setAutolayoutMode(views: [self, mButton])
		#endif
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

	#if os(OSX)
	public var color: CNColor {
		get {
			if let well = mColorWell {
				return well.color
			} else {
				NSLog("No color well for get")
				return CNColor.black
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
	public var color: CNColor {
		get {
			if let button = mButton {
				if let color = button.backgroundColor {
					return color
				}
			}
			NSLog("No color")
			return CNColor.black
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

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		#if os(OSX)
			mColorWell.setFrameSize(newsize)
		#else
			mButton.setFrameSize(size: newsize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get { return defaultSize }
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		#if os(OSX)
			mColorWell.invalidateIntrinsicContentSize()
		#else
			mButton.invalidateIntrinsicContentSize()
		#endif

	}

	public override func setExpandabilities(priorities prival: ExpansionPriorities) {
		#if os(OSX)
			mColorWell.setExpansionPriorities(priorities: prival)
		#else
			mButton.setExpansionPriorities(priorities: prival)
		#endif
		super.setExpandabilities(priorities: prival)
	}
}


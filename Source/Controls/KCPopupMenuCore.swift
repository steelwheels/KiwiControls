/**
 * @file KCPopuoMenuCore.swift
 * @brief Define KCPopupMenuCore class
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

open class KCPopupMenuCore: KCView
{
	public typealias CallbackFunction = (_ index: Int, _ title: String?) -> Void

#if os(OSX)
	@IBOutlet weak var mPopupButton: NSPopUpButton!
	private var mCallbackFunction: CallbackFunction? = nil
#else
	@IBOutlet weak var mPickerView: UIPickerView!
	private var mDelegate:	KCPopupMenuCoreDelegate = KCPopupMenuCoreDelegate()
#endif

	public func setup(frame frm: CGRect) -> Void {
		#if os(OSX)
			KCView.setAutolayoutMode(views: [self, mPopupButton])
		#else
			KCView.setAutolayoutMode(views: [self, mPickerView])
		#endif
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		super.resize(bounds.size)

		#if os(OSX)
			mPopupButton.removeAllItems()
		#else
			let delegate = KCPopupMenuCoreDelegate()
			mPickerView.delegate = delegate
			mDelegate = delegate
		#endif
	}

	#if os(OSX)
	@IBAction func buttonAction(_ sender: Any) {
		if let cbfunc = callbackFunction {
			cbfunc(indexOfSelectedItem, titleOfSelectedItem)
		} else {
			NSLog("Popup menu pressed")
		}
	}
	#endif

	public var callbackFunction: CallbackFunction? {
		get {
			#if os(OSX)
			return mCallbackFunction
			#else
			return mDelegate.callbackFunction
			#endif
		}
		set(newfunc){
			#if os(OSX)
			mCallbackFunction = newfunc
			#else
			mDelegate.callbackFunction = newfunc
			#endif
		}
	}

	public var indexOfSelectedItem: Int {
		get {
			#if os(OSX)
			return mPopupButton.indexOfSelectedItem
			#else
			return mDelegate.indexOfSelectedItem
			#endif
		}
	}

	public var titleOfSelectedItem: String? {
		get {
			#if os(OSX)
			return mPopupButton.titleOfSelectedItem
			#else
			return mDelegate.titleOfSelectedItem
			#endif
		}
	}

	public func itemTitles() -> Array<String> {
		#if os(OSX)
		return mPopupButton.itemTitles
		#else
		return mDelegate.itemTitles()
		#endif
	}

	public func addItems(withTitles titles: Array<String>) {
		#if os(OSX)
			mPopupButton.addItems(withTitles: titles)
		#else
			mDelegate.addItems(withTitles: titles)
		#endif
	}

	open override var fittingSize: KCSize {
		get {
			#if os(OSX)
				return mPopupButton.fittingSize
			#else
				return mPickerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
		}
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		#if os(OSX)
			return mPopupButton.sizeThatFits(size)
		#else
			return mPickerView.sizeThatFits(size)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				#if os(OSX)
					return mPopupButton.intrinsicContentSize
				#else
					return mPickerView.intrinsicContentSize
				#endif
			}
		}
	}
}

#if os(iOS)
@objc private class KCPopupMenuCoreDelegate:NSObject, UIPickerViewDelegate
{
	public var callbackFunction: KCPopupMenuCore.CallbackFunction? = nil

	private var mItems:	Array<String> = []
	private var mIndex:	Int = 0

	public var indexOfSelectedItem: Int {
		get { return mIndex }
	}

	public var titleOfSelectedItem: String? {
		get {
			if 0<=mIndex && mIndex < mItems.count {
				return mItems[mIndex]
			} else {
				return nil
			}
		}
	}

	public func itemTitles() -> Array<String> {
		return mItems
	}

	public func addItems(withTitles titles: Array<String>) {
		mItems.append(contentsOf: titles)
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		mIndex = row
		if mIndex < mItems.count {
			if let cbfunc = callbackFunction {
				cbfunc(mIndex, titleOfSelectedItem)
			}
		}
	}
}
#endif


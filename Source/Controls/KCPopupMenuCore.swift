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

open class KCPopupMenuCore: KCCoreView
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
			super.setup(isSingleView: true, coreView: mPopupButton)
			KCView.setAutolayoutMode(views: [self, mPopupButton])
		#else
			super.setup(isSingleView: true, coreView: mPickerView)
			KCView.setAutolayoutMode(views: [self, mPickerView])
		#endif
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
			CNLog(logLevel: .detail, message: "Popup menu pressed")
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

	public func removeAllItems() {
		#if os(OSX)
			mPopupButton.removeAllItems()
		#else
			mDelegate.removeAllItems()
		#endif
	}

	#if os(OSX)
	open override var fittingSize: KCSize {
		get { return contentSize() }
	}
	#else
	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return contentSize()
	}
	#endif

	open override var intrinsicContentSize: KCSize {
		get { return contentSize() }
	}

	private func contentSize() -> KCSize {
		#if os(OSX)
			var btnsize = mPopupButton.intrinsicContentSize
			if let font = mPopupButton.font {
				btnsize.width  = max(btnsize.width,  font.pointSize * CGFloat(15))
				btnsize.height = max(btnsize.height, font.pointSize * 1.2        )
			}
		#else
			let btnsize = mPickerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		#endif
		let space = CNPreference.shared.windowPreference.spacing
		return KCSize(width:  btnsize.width + space, height: btnsize.height + space)
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

	public func removeAllItems() {
		mItems = []
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


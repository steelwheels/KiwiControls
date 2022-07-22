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
	public struct MenuItem {
		public var title:	String
		public var value:	CNValue

		public init(title tstr: String, value val: CNValue) {
			title	= tstr
			value	= val
		}

		public init(title tstr: String, intValue val: Int) {
			title	= tstr
			value	= .numberValue(NSNumber(integerLiteral: val))
		}
	}
	public typealias CallbackFunction = (_ val: CNValue) -> Void

#if os(OSX)
	@IBOutlet weak var mPopupButton: NSPopUpButton!
	private var mCallbackFunction: CallbackFunction? = nil
	private var mItems:	Array<MenuItem> = []
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
			let idx = self.indexOfSelectedItem
			if 0<=idx && idx<mItems.count {
				cbfunc(mItems[idx].value)
			}
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

	public func selectedValue() -> CNValue? {
		#if os(OSX)
			let idx = indexOfSelectedItem
			if 0<=idx && idx<mItems.count {
				return mItems[idx].value
			} else {
				return nil
			}
		#else
			return mDelegate.selectedValue()
		#endif
	}

	private var indexOfSelectedItem: Int { get {
		#if os(OSX)
			return mPopupButton.indexOfSelectedItem
		#else
			return mDelegate.indexOfSelectedItem
		#endif
	}}

	public func allItems() -> Array<MenuItem> {
		#if os(OSX)
			return mItems
		#else
			return mDelegate.allItems()
		#endif
	}

	public func addItem(_ item: MenuItem) {
		#if os(OSX)
			mPopupButton.addItem(withTitle: item.title)
			mItems.append(item)
		#else
			mDelegate.addItem(item)
		#endif
	}

	public func addItems(_ items: Array<MenuItem>) {
		#if os(OSX)
			mPopupButton.addItems(withTitles: items.map { $0.title })
			mItems.append(contentsOf: items)
		#else
			mDelegate.addItems(items)
		#endif
	}

	public func removeAllItems() {
		#if os(OSX)
			mPopupButton.removeAllItems()
			mItems = []
		#else
			mDelegate.removeAllItems()
		#endif
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
			var btnsize = mPopupButton.intrinsicContentSize
			if let font = mPopupButton.font {
				btnsize.width  = max(btnsize.width,  font.pointSize * CGFloat(15))
				btnsize.height = max(btnsize.height, font.pointSize * 1.2        )
			}
		#else
			let btnsize = mPickerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
		#endif
		let space = CNPreference.shared.windowPreference.spacing
		return CGSize(width:  btnsize.width + space, height: btnsize.height + space)
	}
}

#if os(iOS)
@objc private class KCPopupMenuCoreDelegate:NSObject, UIPickerViewDelegate
{
	public typealias MenuItem = KCPopupMenuCore.MenuItem
	public var callbackFunction: KCPopupMenuCore.CallbackFunction? = nil

	private var mItems:	Array<MenuItem> = []
	private var mIndex:	Int = 0

	public var indexOfSelectedItem: Int {
		get { return mIndex }
	}

	public func allItems() -> Array<MenuItem> {
		return mItems
	}

	public func addItem(_ item: MenuItem) {
		mItems.append(item)
	}

	public func addItems(_ items: Array<MenuItem>) {
		mItems.append(contentsOf: items)
	}

	public func removeAllItems() {
		mItems = []
	}

	public func selectedValue() -> CNValue? {
		let idx = indexOfSelectedItem
		if 0<=idx && idx<mItems.count {
			return mItems[idx].value
		} else {
			return nil
		}
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		mIndex = row
		if mIndex < mItems.count {
			if let cbfunc = callbackFunction {
				cbfunc(mItems[mIndex].value)
			}
		}
	}
}
#endif


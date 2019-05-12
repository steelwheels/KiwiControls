/**
 * @file KCNavigationBarCore.swift
 * @brief Define KCNavigationBarCore class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

open class KCNavigationBarCore: KCView
{
	public var leftBarButtonPressedCallback		: (() -> Void)? = nil
	public var rightBarButtonPressedCallback	: (() -> Void)? = nil

	#if os(OSX)
	@IBOutlet weak var mNavigationBar	: KCView!
	@IBOutlet weak var mNavigationItem	: NSTextField!
	@IBOutlet weak var leftBarButton	: NSButton!
	@IBOutlet weak var rightBarButton	: NSButton!
	#else
	@IBOutlet weak var mNavigationBar	: UINavigationBar!
	@IBOutlet weak var mNavigationItem	: UINavigationItem!
	@IBOutlet weak var leftBarButton	: UIBarButtonItem!
	@IBOutlet weak var rightBarButton	: UIBarButtonItem!
	#endif


	public func setup(frame frm: CGRect){
		self.rebounds(origin: KCPoint.zero, size: frm.size)

		self.title = ""

		self.isLeftButtonEnabled		= false
		self.leftButtonTitle			= ""
		self.leftBarButtonPressedCallback	= nil

		self.isRightButtonEnabled		= false
		self.rightButtonTitle			= ""
		self.rightBarButtonPressedCallback	= nil
	}

	public var title: String {
		get {
			#if os(OSX)
				return mNavigationItem.stringValue
			#else
				if let str = mNavigationItem.title {
					return str
				} else {
					return ""
				}
			#endif
		}
		set(str) {
			#if os(OSX)
				mNavigationItem.stringValue = str
			#else
				mNavigationItem.title = str
			#endif
		}
	}

	public var isLeftButtonEnabled: Bool {
		get {
			return leftBarButton.isEnabled
		}
		set(enable){
			leftBarButton.isEnabled = enable
			#if os(OSX)
				leftBarButton.isHidden  = !enable
			#endif
		}
	}

	public var leftButtonTitle: String {
		get {
			#if os(OSX)
				return leftBarButton.title
			#else
				if let title = leftBarButton.title {
					return title
				} else {
					return ""
				}
			#endif
		}
		set(str){
			leftBarButton.title = str
		}
	}

	public var leftButtonPressedCallback: (() -> Void)? {
		get {
			return leftBarButtonPressedCallback
		}
		set(cbfunc) {
			leftBarButtonPressedCallback = cbfunc
		}
	}

	public var isRightButtonEnabled: Bool {
		get {
			return rightBarButton.isEnabled
		}
		set(enable){
			rightBarButton.isEnabled = enable
			#if os(OSX)
				rightBarButton.isHidden  = !enable
			#endif
		}
	}
	
	public var rightButtonTitle: String {
		get {
			#if os(OSX)
				return rightBarButton.title
			#else
				if let title = rightBarButton.title {
					return title
				} else {
					return ""
				}
			#endif
		}
		set(str){
			rightBarButton.title = str
		}
	}

	public var rightButtonPressedCallback: (() -> Void)? {
		get {
			return rightBarButtonPressedCallback
		}
		set(cbfunc) {
			rightBarButtonPressedCallback = cbfunc
		}
	}

	@IBAction func leftButtonPressed(_ sender: Any) {
		if let cbfunc = leftBarButtonPressedCallback {
			cbfunc()
		}
	}

	@IBAction func rightButtonPressed(_ sender: Any) {
		if let cbfunc = rightBarButtonPressedCallback {
			cbfunc()
		}
	}
	
	open override func sizeToFit() {
		#if os(OSX)
			/* Resize children */
			mNavigationItem.sizeToFit()
			leftBarButton.sizeToFit()
			rightBarButton.sizeToFit()

			/* Calc union size */
			let navsize   = mNavigationItem.frame.size
			let leftsize  = leftBarButton.frame.size
			let rightsize = rightBarButton.frame.size

			let space  = CNPreference.shared.layoutPreference.spacing
			let height = max(navsize.height, leftsize.height, rightsize.height)
			let width  = leftsize.width + space + navsize.width + space + rightsize.width
			super.resize(KCSize(width: width, height: height))
		#else
			mNavigationBar.sizeToFit()
			super.resize(mNavigationBar.frame.size)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			return mNavigationBar.intrinsicContentSize
		}
	}
}


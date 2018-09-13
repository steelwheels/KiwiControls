/*
 * @file	KCButtonCore.swift
 * @brief	Define KCButtonCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

public class KCButtonCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mButton: UIButton!
	#else
	@IBOutlet weak var mButton: KCButtonBody!
	#endif

	public var buttonPressedCallback: (() -> Void)? = nil

	public func setup(frame frm: CGRect) -> Void {
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		resize(newSize: bounds.size)
	}

	open override func sizeToFit() {
		mButton.sizeToFit()
		resize(newSize: mButton.frame.size)
	}

	#if os(iOS)
	@IBAction func buttonPressed(_ sender: UIButton) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#else
	@IBAction func buttonPressed(_ sender: NSButton) {
		if let callback = buttonPressedCallback {
			callback()
		}
	}
	#endif

	public var title: String {
		get {
			#if os(iOS)
				if let title = mButton.currentTitle {
					return title
				} else {
					return ""
				}
			#else
				return mButton.title
			#endif
		}
		set(newstr){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mButton.setTitle(newstr, for: .normal)
				#else
					self.mButton.title = newstr
				#endif
			})
		}
	}

	public var isEnabled: Bool {
		get {
			return mButton.isEnabled
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				self.mButton.isEnabled   = newval
			})
		}
	}

	public func setColors(colors cols: KCColorPreference.ButtonColors){
		CNExecuteInMainThread(doSync: false, execute: { () -> Void in
			#if os(iOS)
				self.mButton.setTitleColor(cols.title, for: .normal)
				self.mButton.backgroundColor = cols.background.normal
				self.backgroundColor = cols.background.normal
			#else
				self.mButton.colors = cols
			#endif
		})
	}

	open override var intrinsicContentSize: KCSize {
		get {
			return mButton.intrinsicContentSize
		}
	}
}


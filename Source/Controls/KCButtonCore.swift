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
import KiwiGraphics

public class KCButtonCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mButton: UIButton!
	#else
	@IBOutlet weak var mButton: NSButton!
	#endif

	public var buttonPressedCallback: (() -> Void)? = nil

	public func setup() -> Void {
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
			#if os(iOS)
				mButton.setTitle(newstr, for: .normal)
			#else
				mButton.title = newstr
			#endif
		}
	}

	public var isEnabled: Bool {
		get {
			return mButton.isEnabled
		}
		set(newval){
			mButton.isEnabled   = newval
		}
	}

	public var isVisible: Bool {
		get {
			return !(mButton.isHidden)
		}
		set(newval){
			mButton.isHidden   = !newval
		}
	}
}


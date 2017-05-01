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
import Canary

public class KCButtonCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mButton: UIButton!
	#else
	@IBOutlet weak var mButton: KCButtonBody!
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

	public func setColors(colors cols: KGColorPreference.ButtonColors){
		#if os(iOS)
			mButton.setTitleColor(cols.title, for: .normal)
			mButton.backgroundColor = cols.background.normal
			self.backgroundColor = cols.background.normal
		#else
			mButton.colors = cols
		#endif
	}

	open override func printDebugInfo(indent idt: Int){
		super.printDebugInfo(indent: idt)
		if let v = mButton {
			v.printDebugInfo(indent: idt+1)
		}
	}
}


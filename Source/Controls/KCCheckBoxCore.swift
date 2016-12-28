/*
 * @file	KCCheckBoxCore.swift
 * @brief	Define KCCheckBoxCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import KiwiGraphics

public class KCCheckBoxCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mSwitch: UISwitch!
	@IBOutlet weak var mLabel: UILabel!
	#else
	@IBOutlet weak var mCheckBox: NSButton!
	#endif
	
	public var checkUpdatedCallback: ((_ value: Bool) -> Void)? = nil

	public func setup() -> Void {
	}

	#if os(iOS)
	@IBAction func checkUpdated(_ sender: UISwitch) {
		if let updatecallback = checkUpdatedCallback {
			let ison = sender.isOn
			updatecallback(ison)
		}
	}
	#else
	@IBAction func checkUpdated(_ sender: NSButton) {
		if let updatecallback = checkUpdatedCallback {
			let ison = sender.state == NSOnState
			updatecallback(ison)
		}
	}
	#endif

	public var isEnabled: Bool {
		get {
			#if os(iOS)
			return mSwitch.isEnabled
			#else
			return mCheckBox.isEnabled
			#endif
		}
		set(newval){
			#if os(iOS)
			mSwitch.isEnabled = newval
			mLabel.isEnabled  = newval
			#else
			mCheckBox.isEnabled   = newval
			#endif
		}
	}

	public var isVisible: Bool {
		get {
			#if os(iOS)
			return !(mSwitch.isHidden)
			#else
			return !(mCheckBox.isHidden)
			#endif
		}
		set(newval){
			let nnewval = !newval
			#if os(iOS)
			mSwitch.isEnabled  = nnewval
			mLabel.isEnabled   = nnewval
			#else
			mCheckBox.isHidden = nnewval
			#endif
		}
	}
}


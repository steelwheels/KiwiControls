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
import CoconutData

public class KCCheckBoxCore: KCView
{
	#if os(iOS)
	@IBOutlet weak var mSwitch: UISwitch!
	@IBOutlet weak var mLabel: UILabel!
	#else
	@IBOutlet weak var mCheckBox: NSButton!
	#endif

	public var checkUpdatedCallback: ((_ value: Bool) -> Void)? = nil

	public func setup(frame frm: CGRect) -> Void
	{
		self.rebounds(origin: KCPoint.zero, size: frm.size)
	}

	open override func sizeToFit() {
		#if os(OSX)
			mCheckBox.sizeToFit()
			let coresize = mCheckBox.frame.size
		#else
			mSwitch.sizeToFit()
			mLabel.sizeToFit()
			let coresize = KCUnionSize(sizeA: mSwitch.frame.size, sizeB: mLabel.frame.size, doVertical: false)
		#endif
		super.resize(coresize)
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
			let ison = (sender.state == .on)
			updatecallback(ison)
		}
	}
	#endif

	public var title: String {
		get {
			#if os(iOS)
				if let text = mLabel.text {
					return text
				} else {
					return ""
				}
			#else
				return mCheckBox.title
			#endif
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mLabel.text = newval
					#else
						myself.mCheckBox.title = newval
					#endif
				}
			})
		}
	}

	public var isEnabled: Bool {
		get {
			#if os(iOS)
				return mSwitch.isEnabled
			#else
				return mCheckBox.isEnabled
			#endif
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mSwitch.isEnabled = newval
						myself.mLabel.isEnabled  = newval
					#else
						myself.mCheckBox.isEnabled   = newval
					#endif
				}
			})
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					let nnewval = !newval
					#if os(iOS)
						myself.mSwitch.isHidden   = nnewval
						myself.mLabel.isHidden    = nnewval
					#else
						myself.mCheckBox.isHidden = nnewval
					#endif
				}
			})
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			#if os(iOS)
				let labelsize  = mLabel.intrinsicContentSize
				let switchsize = mSwitch.intrinsicContentSize
				return KCUnionSize(sizeA: labelsize, sizeB: switchsize, doVertical: false)
			#else
				return mCheckBox.intrinsicContentSize
			#endif
		}
	}
}


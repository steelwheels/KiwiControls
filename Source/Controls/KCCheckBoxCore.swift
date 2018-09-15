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
		let bounds = CGRect(origin: CGPoint.zero, size: frm.size)
		self.frame  = bounds
		self.bounds = bounds
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mLabel.text = newval
				#else
					self.mCheckBox.title = newval
				#endif
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				#if os(iOS)
					self.mSwitch.isEnabled = newval
					self.mLabel.isEnabled  = newval
				#else
					self.mCheckBox.isEnabled   = newval
				#endif
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
			CNExecuteInMainThread(doSync: false, execute: { () -> Void in
				let nnewval = !newval
				#if os(iOS)
					self.mSwitch.isHidden   = nnewval
					self.mLabel.isHidden    = nnewval
				#else
					self.mCheckBox.isHidden = nnewval
				#endif
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


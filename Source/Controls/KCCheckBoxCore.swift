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

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		#if os(OSX)
			return mCheckBox.sizeThatFits(size)
		#else
			let swsize  = mSwitch.sizeThatFits(size)
			let labsize = mLabel.sizeThatFits(size)
			return KCUnionSize(sizeA: swsize, sizeB: labsize, doVertical: false)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
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

	open override func resize(_ size: KCSize) {
		#if os(OSX)
			mCheckBox.frame.size  = size
			mCheckBox.bounds.size = size
		#else
			let swsize = mSwitch.frame.size
			let labsize: KCSize
			if size.width > swsize.width {
				labsize = KCSize(width: size.width - swsize.width, height: size.height)
			} else {
				labsize = KCSize(width: 1.0, height: size.height)
			}
			mLabel.frame.size          = labsize
			mLabel.bounds.size         = labsize
			mSwitch.frame.size.height  = labsize.height
			mSwitch.bounds.size.height = labsize.height
		#endif
		super.resize(size)
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
}


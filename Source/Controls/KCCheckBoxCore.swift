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
		#if os(OSX)
			KCView.setAutolayoutMode(views: [self, mCheckBox])
		#else
			KCView.setAutolayoutMode(views: [self, mSwitch, mLabel])
		#endif
	}

	open override func setFrameSize(_ newsize: KCSize) {
		super.setFrameSize(newsize)
		#if os(iOS)
			let totalwidth  = newsize.width
			var labelwidth  = mLabel.intrinsicContentSize.width
			var switchwidth = totalwidth - labelwidth
			if switchwidth < 0.0 {
				labelwidth  = totalwidth / 2.0
				switchwidth = totalwidth / 2.0
			}
			mSwitch.setFrameSize(size: KCSize(width: switchwidth, height: newsize.height))
			mLabel.setFrameSize(size: KCSize(width: labelwidth, height: newsize.height))
		#else
			mCheckBox.setFrameSize(newsize)
		#endif
	}

	open override var intrinsicContentSize: KCSize {
		get {
			#if os(iOS)
				let labelsize  = mLabel.intrinsicContentSize
				let switchsize = mSwitch.intrinsicContentSize
				let space   = CNPreference.shared.windowPreference.spacing
				return KCUnionSize(sizeA: labelsize, sizeB: switchsize, doVertical: false, spacing: space)
			#else
				return mCheckBox.intrinsicContentSize
			#endif
		}
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		#if os(iOS)
			mLabel.invalidateIntrinsicContentSize()
			mSwitch.invalidateIntrinsicContentSize()
		#else
			mCheckBox.invalidateIntrinsicContentSize()
		#endif
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

	public var status: Bool {
		get {
			let result: Bool
			#if os(OSX)
				switch mCheckBox.state {
				case .mixed:	result = false
				case .off:	result = false
				case .on:	result = true
				default:	result = false
				}
			#else
				result = mSwitch.isOn
			#endif
			return result
		}
		set(newval) {
			#if os(OSX)
				mCheckBox.state = newval ? .on : .off
			#else
				mSwitch.isOn = newval
			#endif
		}
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		#if os(OSX)
			mCheckBox.setExpansionPriorities(priorities: prival)
		#else
			mSwitch.setExpansionPriorities(priorities: prival)
			mLabel.setExpansionPriorities(priorities: prival)
		#endif
		super.setExpandabilities(priorities: prival)
	}
}


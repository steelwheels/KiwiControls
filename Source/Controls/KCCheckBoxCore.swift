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

public class KCCheckBoxCore: KCCoreView
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
			super.setup(isSingleView: true, coreView: mCheckBox)
			KCView.setAutolayoutMode(views: [self, mCheckBox])
		#else
			super.setup(isSingleView: false, coreView: mSwitch)
			KCView.setAutolayoutMode(views: [self, mSwitch, mLabel])
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
			#if os(iOS)
				self.mLabel.text = newval
			#else
				self.mCheckBox.title = newval
			#endif
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
			#if os(iOS)
				self.mSwitch.isEnabled = newval
				self.mLabel.isEnabled  = newval
			#else
				self.mCheckBox.isEnabled   = newval
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
			#if os(iOS)
				self.mSwitch.isHidden   = !newval
				self.mLabel.isHidden    = !newval
			#else
				self.mCheckBox.isHidden = !newval
			#endif
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

	open override func setFrameSize(_ newsize: CGSize) {
		super.setFrameSize(newsize)
		#if os(iOS)
			let totalwidth  = newsize.width
			var labelwidth  = mLabel.intrinsicContentSize.width
			var switchwidth = totalwidth - labelwidth
			if switchwidth < 0.0 {
				labelwidth  = totalwidth / 2.0
				switchwidth = totalwidth / 2.0
			}
			mSwitch.setFrame(size: CGSize(width: switchwidth, height: newsize.height))
			mLabel.setFrame(size: CGSize(width: labelwidth, height: newsize.height))
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
		#if os(iOS)
			let labelsize  = mLabel.intrinsicContentSize
			let switchsize = mSwitch.intrinsicContentSize
			let space   = CNPreference.shared.windowPreference.spacing
			return CNUnionSize(sizeA: labelsize, sizeB: switchsize, doVertical: false, spacing: space)
		#else
			return super.intrinsicContentSize
		#endif
	}

	public override func invalidateIntrinsicContentSize() {
		super.invalidateIntrinsicContentSize()
		#if os(iOS)
			mLabel.invalidateIntrinsicContentSize()
		#endif
	}

	public override func setExpandabilities(priorities prival: KCViewBase.ExpansionPriorities) {
		super.setExpandabilities(priorities: prival)
		#if os(OSX)
			mCheckBox.setExpansionPriorities(priorities: prival)
		#else
			let fixpri = KCViewBase.ExpansionPriorities(holizontalHugging: .fixed,
								    holizontalCompression: .fixed,
								    verticalHugging: .fixed,
								    verticalCompression: .fixed)
			mSwitch.setExpansionPriorities(priorities: fixpri)
			mLabel.setExpansionPriorities(priorities: prival)
		#endif
	}
}


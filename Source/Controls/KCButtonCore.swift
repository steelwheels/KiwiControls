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

public class KCButtonCore: KCCoreView
{
	#if os(iOS)
	@IBOutlet weak var mButton: UIButton!
	#else
	@IBOutlet weak var mButton: KCButtonBody!
	#endif

	public var buttonPressedCallback: (() -> Void)? = nil

	public func setup(frame frm: CGRect) -> Void {
		super.setup(isSingleView: true, coreView: mButton)
		KCView.setAutolayoutMode(views: [self, mButton])
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
				self.mButton.setTitle(newstr, for: .normal)
			#else
				self.mButton.title = newstr
			#endif
		}
	}

	public var isEnabled: Bool {
		get {
			return mButton.isEnabled
		}
		set(newval){
			self.mButton.isEnabled   = newval
		}
	}
}


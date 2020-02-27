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
		KCView.setAutolayoutMode(views: [self, mButton])
		let bounds  = CGRect(origin: CGPoint.zero, size: frm.size)
		super.resize(bounds.size)
	}

	open override var fittingSize: KCSize {
		get {
			#if os(OSX)
				return mButton.fittingSize
			#else
				return mButton.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
			#endif
		}
	}

	open override var intrinsicContentSize: KCSize {
		get {
			if hasFixedSize {
				return super.intrinsicContentSize
			} else {
				return mButton.intrinsicContentSize
			}
		}
	}

	open override func resize(_ size: KCSize) {
		mButton.frame.size  = size
		mButton.bounds.size = size
		super.resize(size)
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
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					#if os(iOS)
						myself.mButton.setTitle(newstr, for: .normal)
					#else
						myself.mButton.title = newstr
					#endif
				}
			})
		}
	}

	public var isEnabled: Bool {
		get {
			return mButton.isEnabled
		}
		set(newval){
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.mButton.isEnabled   = newval
				}
			})
		}
	}

	public func setColors(colors cols: KCColorPreference.ButtonColors){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				#if os(iOS)
					myself.mButton.setTitleColor(cols.title, for: .normal)
					myself.mButton.backgroundColor = cols.background.normal
					myself.backgroundColor = cols.background.normal
				#else
					myself.mButton.colors = cols
				#endif
			}
		})
	}
}


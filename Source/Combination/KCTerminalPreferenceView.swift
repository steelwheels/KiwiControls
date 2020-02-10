/**
 * @file	KCTerminalPreferenceView.swift
 * @brief	Define KCTerminalPreferenceView class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

public class KCTerminalPreferenceView: KCStackView
{
	public typealias CallbackFunction = KCColorSelectorCore.CallbackFunction

	private var 	mLabel:				KCTextField?		= nil
	private var	mTextColorSelector:		KCColorSelector?	= nil
	private var	mBackgroundColorSelector:	KCColorSelector?	= nil

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setupContext()
	}
	#endif

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		NSLog("Not supported")
	}

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#endif
		self.init(frame: frame)
	}

	private func setupContext() {
		allocateView()

		/* Set initial values */
		let pref = CNPreference.shared.terminalPreference
		if let col = pref.textColor {
			self.textColor = col
		}
		if let col = pref.backgroundColor {
			self.backgroundColor = col
		}
	}

	private func allocateView() {
		/* Allocate parts vertically */
		super.axis = .vertical

		/* Add label */
		let label = KCTextField()
		label.text = "Terminal size"
		mLabel = label

		/* Add text color selector */
		let textsel = KCColorSelector()
		textsel.setLabel(string: "Text:")
		textsel.callbackFunc = {
			(_ color: KCColor) -> Void in
			let pref = CNPreference.shared.terminalPreference
			pref.textColor = color
		}
		mTextColorSelector = textsel

		/* Add backlight color selector */
		let backsel = KCColorSelector()
		backsel.setLabel(string: "Background:")
		backsel.callbackFunc = {
			(_ color: KCColor) -> Void in
			let pref = CNPreference.shared.terminalPreference
			pref.backgroundColor = color
		}
		mBackgroundColorSelector = backsel

		/* Bind selectors */
		let box = KCStackView()
		box.axis = .horizontal
		box.addArrangedSubViews(subViews: [textsel, backsel])

		super.addArrangedSubViews(subViews: [label, box])
	}

	public var textColor: KCColor {
		get		{ return getColor(from: mTextColorSelector)	  }
		set(newcol) 	{ setColor(to: mTextColorSelector, color: newcol) }
	}

	public var backgroundColor: KCColor {
		get		{ return getColor(from: mBackgroundColorSelector)	}
		set(newcol) 	{ setColor(to: mBackgroundColorSelector, color: newcol)	}
	}

	private func getColor(from selector: KCColorSelector?) -> KCColor {
		if let sel = selector {
			return sel.color
		} else {
			NSLog("No selector")
			return KCColor.black
		}
	}

	private func setColor(to selector: KCColorSelector?, color col: KCColor) {
		if let sel = selector {
			sel.color = col
		} else {
			NSLog("No selector")
		}
	}
}

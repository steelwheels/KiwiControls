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

	public var textColorCallbackFunc:		CallbackFunction?
	public var backgroundColorCallbackFunc:		CallbackFunction?

	private var 	mLabel:				KCTextField?		= nil
	private var	mTextColorSelector:		KCColorSelector?	= nil
	private var	mBackgroundColorSelector:	KCColorSelector?	= nil

	#if os(OSX)
	public override init(frame : NSRect){
		textColorCallbackFunc		= nil
		backgroundColorCallbackFunc	= nil
		super.init(frame: frame) ;
		setupContext() ;
	}
	#else
	public override init(frame: CGRect){
		textColorCallbackFunc		= nil
		backgroundColorCallbackFunc	= nil
		super.init(frame: frame) ;
		setupContext()
	}
	#endif

	public required init?(coder: NSCoder) {
		textColorCallbackFunc		= nil
		backgroundColorCallbackFunc	= nil
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
			if let cbfunc = self.textColorCallbackFunc {
				cbfunc(color)
			}
		}
		mTextColorSelector = textsel

		/* Add backlight color selector */
		let backsel = KCColorSelector()
		backsel.setLabel(string: "Background:")
		backsel.callbackFunc = {
			(_ color: KCColor) -> Void in
			if let cbfunc = self.backgroundColorCallbackFunc {
				cbfunc(color)
			}
		}
		mBackgroundColorSelector = backsel

		super.addArrangedSubViews(subViews: [label, textsel, backsel])
	}
}

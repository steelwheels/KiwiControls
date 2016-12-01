/**
 * @file	KCTimerView.swift
 * @brief	Define KCTimerView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

open class KCTimerView : KCView
{
	private var	mCoreView : KCTimerViewCore?	= nil

	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let coreview = loadChildXib(thisClass: KCTimerView.self, nibName: "KCTimerViewCore") as? KCTimerViewCore {
			mCoreView = coreview
		} else {
			fatalError("Can not load KCTimerViewCore")
		}
	}
}

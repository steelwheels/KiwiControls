/**
 * @file KCStackView.swift
 * @brief Define KCStackView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import KiwiGraphics
import Canary

open class KCStackView : KCView
{
	private var mCoreView : KCStackViewCore?	= nil

	private var coreView: KCStackViewCore {
		get {
			if let cview = mCoreView {
				return cview
			} else {
				fatalError("No core view")
			}
		}
	}

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
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let coreview = loadChildXib(thisClass: KCStackView.self, nibName: "KCStackViewCore") as? KCStackViewCore {
			mCoreView = coreview
		} else {
			fatalError("Can not load KCStackCore")
		}
	}
}


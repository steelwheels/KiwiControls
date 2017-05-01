/**
 * @file	KCIconView.swift
 * @brief	Define KCIconView class
 * @par Copyright
 *   Copyright (C) 017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import KiwiGraphics

open class KCIconView: KCCoreView
{
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
		if let newview = loadChildXib(thisClass: KCIconView.self, nibName: "KCIconViewCore") as? KCIconViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
		} else {
			fatalError("Can not load KCIconViewCore")
		}
	}

	public var imageDrawer: KGImageDrawer? {
		get { return coreView.imageDrawer }
		set(drawer){ coreView.imageDrawer = drawer }
	}

	public var label: String {
		get { return coreView.label }
		set(str){ coreView.label = str }
	}

	private var coreView: KCIconViewCore {
		get { return super.getCoreView() }
	}
}

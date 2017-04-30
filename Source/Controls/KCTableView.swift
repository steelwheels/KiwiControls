/**
 * @file	KCTableView.swift
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import KiwiGraphics
import Canary

open class KCTableView : KCCoreView
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
		if let newview = loadChildXib(thisClass: KCTableView.self, nibName: "KCTableViewCore") as? KCTableViewCore {
			setCoreView(view: newview)
		} else {
			fatalError("Can not load KCTextFieldCore")
		}
	}

	private var coreView: KCTableViewCore {
		get { return getCoreView() }
	}
}



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

open class KCTableView : KCView
{
	private var mCoreView : KCTableViewCore?	= nil

	private var coreView: KCTableViewCore {
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
		if let coreview = loadChildXib(thisClass: KCTableView.self, nibName: "KCTableViewCore") as? KCTableViewCore {
			mCoreView = coreview
		} else {
			fatalError("Can not load KCTextFieldCore")
		}
	}

	public final override func observe(state stat: CNState){
	}
}


/*
public override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
//Swift.print("validate")
if let textfield = responder as? NSTextField {
return textfield.isEditable
}
return super.validateProposedFirstResponder(responder, for: event)
}
*/

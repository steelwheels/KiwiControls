/**
 * @file	KCTextField.swift
 * @brief	Define KCTextField class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import Canary
import KiwiGraphics

open class KCTextField : KCView
{
	private var mCoreView : KCTextFieldCore?	= nil

	private var coreView: KCTextFieldCore {
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
		if let coreview = loadChildXib(thisClass: KCTextField.self, nibName: "KCTextFieldCore") as? KCTextFieldCore {
			mCoreView = coreview
		} else {
			fatalError("Can not load KCTextFieldCore")
		}
	}

	public var text: String {
		get { return coreView.text }
		set(newval){ coreView.text = newval }
	}

	public var alignment: NSTextAlignment {
		get	  { return coreView.alignment }
		set(align){ coreView.alignment = align }
	}

	public func setColors(colors cols: KGColorPreference.TextColors){
		coreView.setColors(colors: cols)
	}

	public func setDouble(value val: Double) {
		let valstr = String(format: "%4.2lf", val)
		text = valstr
	}

	public var decideTextCallback : ((_: CNState) -> String?)? = nil

	public final override func observe(state stat: CNState){
		if let dectext = decideTextCallback {
			if let text = dectext(stat) {
				coreView.text = text
			}
		}
	}
}

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

open class KCTextField : KCCoreView
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
		if let newview = loadChildXib(thisClass: KCTextField.self, nibName: "KCTextFieldCore") as? KCTextFieldCore {
			setCoreView(view: newview)
		} else {
			fatalError("Can not load KCTextFieldCore")
		}
	}

	public var text: String {
		get { return coreView.text }
		set(newval){ coreView.text = newval }
	}

	public var font: KGFont? {
		get		{ return coreView.font }
		set(font)	{ coreView.font = font }
	}

	public var alignment: NSTextAlignment {
		get	  { return coreView.alignment }
		set(align){ coreView.alignment = align }
	}

	public func setColors(colors cols: KGColorPreference.TextColors){
		coreView.setColors(colors: cols)
		#if os(iOS)
			self.backgroundColor = cols.background
		#endif
	}

	public func setDouble(value val: Double) {
		let rval   = round(value: val, atPoint: 2)
		let valstr = String(format: "%4.2lf", rval)
		text = valstr
	}

	private var coreView: KCTextFieldCore {
		get { return getCoreView() }
	}
}

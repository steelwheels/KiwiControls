/**
 * @file	KCTextEdit.swift
 * @brief	Define KCTextEdit class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

open class KCTextEdit : KCCoreView
{
	public typealias ModeType	  = KCTextEditCore.ModeType
	public typealias CallbackFunction = KCTextEditCore.CallbackFunction

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setup() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setup()
	}
	#endif

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCTextEdit.self, nibName: "KCTextEditCore") as? KCTextEditCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTextEditCore")
		}
	}

	public var mode: ModeType {
		get { return coreView.mode }
		set(v) { coreView.mode = v }
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var callbackFunction: CallbackFunction? {
		get { return coreView.callbackFunction	}
		set(v) { coreView.callbackFunction = v 	}
	}

	public var text: String {
		get { return coreView.text }
		set(newval){ coreView.text = newval }
	}

	public var font: CNFont? {
		get		{ return coreView.font }
		set(font)	{ coreView.font = font }
	}

	public var alignment: NSTextAlignment {
		get	  { return coreView.alignment }
		set(align){ coreView.alignment = align }
	}

	public func setColors(colors cols: KCColorPreference.TextColors){
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

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(textEdit: self)
	}

	private var coreView: KCTextEditCore {
		get { return getCoreView() }
	}
}


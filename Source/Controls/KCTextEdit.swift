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
	public typealias Format		  = KCTextEditCore.Format
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

	public var format: Format {
		get		{ return coreView.format }
		set(newform)	{ coreView.format = newform }
	}

	public var defaultLength: Int {
		get		{ return coreView.defaultLength   }
		set(newlen)	{ coreView.defaultLength = newlen }
	}

	public var isEditable: Bool {
		get 		{ return coreView.isEditable	}
		set(newval)	{ coreView.isEditable = newval	}
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var isBezeled: Bool {
		get { return coreView.isBezeled }
		set(v) { coreView.isBezeled = v }
	}

	public var callbackFunction: CallbackFunction? {
		get { return coreView.callbackFunction	}
		set(v) { coreView.callbackFunction = v 	}
	}

	#if os(OSX)
	public var preferredTextFieldWidth: CGFloat {
		get           { return coreView.preferredTextFieldWidth }
		set(newwidth) { coreView.preferredTextFieldWidth = newwidth }
	}
	#endif

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


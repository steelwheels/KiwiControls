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
import CoconutData

open class KCTextField : KCCoreView
{
	public typealias FormatterType = KCTextFieldCore.FormatterType

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
		setupContext() ;
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCTextField.self, nibName: "KCTextFieldCore") as? KCTextFieldCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCTextFieldCore")
		}
	}

	public func set(format form: FormatterType){
		coreView.set(format: form)
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.High, .Fixed)  // The hight is fixed
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var text: String {
		get { return coreView.text }
		set(newval){ coreView.text = newval }
	}

	public var font: CNFont? {
		get		{ return coreView.font }
		set(font)	{ coreView.font = font }
	}

	public var textColor: KCColor? {
		get      { return coreView.textColor }
		set(col) { coreView.textColor = col }
	}

	#if os(OSX)
	public var backgroundColor: KCColor? {
		get      { return coreView.backgroundColor }
		set(col) { coreView.backgroundColor = col }
	}
	#else
	public override var backgroundColor: KCColor? {
		get      { return coreView.backgroundColor }
		set(col) { coreView.backgroundColor = col }
	}
	#endif

	public var alignment: NSTextAlignment {
		get	  { return coreView.alignment }
		set(align){ coreView.alignment = align }
	}

	public var lineBreak: KCLineBreakMode {
		get	  { return coreView.lineBreak	}
		set(mode) { coreView.lineBreak = mode	}
	}

	public func setDouble(value val: Double) {
		let rval   = round(value: val, atPoint: 2)
		let valstr = String(format: "%4.2lf", rval)
		text = valstr
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(textField: self)
	}

	private var coreView: KCTextFieldCore {
		get { return getCoreView() }
	}
}

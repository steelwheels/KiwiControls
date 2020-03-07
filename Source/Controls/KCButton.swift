/**
 * @file	KCButton.swift
 * @brief	Define KCButton class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

open class KCButton: KCCoreView
{
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame)
		setup(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame)
		setup(frame: frame)
	}
	#endif

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 188, height: 21)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup(frame: self.frame)
	}

	private func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCButton.self, nibName: "KCButtonCore") as? KCButtonCore {
			setCoreView(view: newview)
			newview.setup(frame: frm)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCButtonCore")
		}
	}

	public var buttonPressedCallback: (() -> Void)? {
		get { return coreView.buttonPressedCallback }
		set(callback){ coreView.buttonPressedCallback = callback }
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var title: String {
		get { return coreView.title }
		set(newstr){ coreView.title = newstr }
	}

	public func setColors(colors cols: KCColorPreference.ButtonColors){
		coreView.setColors(colors: cols)
		#if os(iOS)
			self.backgroundColor = cols.background.normal
		#endif
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(button: self)
	}

	private var coreView : KCButtonCore {
		get { return getCoreView() }
	}
}


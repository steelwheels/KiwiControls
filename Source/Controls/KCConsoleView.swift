/**
 * @file	KCConsoleView.swift
 * @brief Define KCConsoleView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

public class KCConsole: CNConsole
{
	private var mOwnerView:	KCConsoleView

	public init(ownerView owner: KCConsoleView){
		mOwnerView = owner
	}

	public override func print(string str: String){
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			let col  = self.mOwnerView.color.normalColor
			let astr = self.attributedString(string: str, foregroundColor: col)
			self.mOwnerView.appendText(string: astr)
		})
	}

	public override  func error(string str: String){
		CNExecuteInMainThread(doSync: false, execute: {
			() -> Void in
			let col  = self.mOwnerView.color.errorColor
			let astr = self.attributedString(string: str, foregroundColor: col)
			self.mOwnerView.appendText(string: astr)
		})
	}

	private func attributedString(string str: String, foregroundColor fgcolor: KCColor) -> NSAttributedString {
		let bgcolor = mOwnerView.color.backgroundColor
		let attrs: [KCStringAttribute] = [.foregroundColor(fgcolor), .backgroundColor(bgcolor)]
		return NSAttributedString(string: str, stringAttributes: attrs)
	}

	public override  func scan() -> String? {
		return nil
	}
}

open class KCConsoleView : KCCoreView
{
	private var mConsole: KCConsole? = nil

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
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 22)
		#endif
		self.init(frame: frame)
		setupContext()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCConsoleView.self, nibName: "KCConsoleViewCore") as? KCConsoleViewCore {
			mConsole = KCConsole(ownerView: self)
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCConsoleViewCore")
		}
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.High, .High)
	}

	public var console: CNConsole {
		get { return mConsole! }
	}

	public func appendText(string str: NSAttributedString){
		coreView.appendText(string: str)
	}

	public var color: KCTextColor {
		get	 { return coreView.color }
		set(col) { coreView.color = col}
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(consoleView: self)
	}

	private var coreView: KCConsoleViewCore {
		get { return getCoreView() }
	}
}

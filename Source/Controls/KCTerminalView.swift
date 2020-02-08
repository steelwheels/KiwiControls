/**
 * @file	KCTerminalView.swift
 * @brief Define KCTerminalView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import CoconutData

open class KCTerminalView : KCCoreView
{
	private var mTextColorListener		: CNPreferenceListner?	= nil
	private var mBackgroundColorListner	: CNPreferenceListner?  = nil

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

	deinit {
		let pref = CNPreference.shared.terminalPreference
		if let listner = mTextColorListener	 { pref.removeObserver(listner: listner) }
		if let listner = mBackgroundColorListner { pref.removeObserver(listner: listner) }
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	public var inputFileHandle: FileHandle {
		get { return coreView.inputFileHandle }
	}

	public var outputFileHandle: FileHandle {
		get { return coreView.outputFileHandle }
	}

	public var errorFileHandle: FileHandle {
		get { return coreView.errorFileHandle }
	}

	public var textColor: KCColor? {
		get		{ return coreView.textColor }
		set(newcol)	{ coreView.textColor = newcol }
	}

	#if os(OSX)
	public var backgroundColor: KCColor? {
		get		{ return coreView.backgroundColor }
		set(newcol)	{ coreView.backgroundColor = newcol }
	}
	#else
	public override var backgroundColor: KCColor? {
		get		{ return coreView.backgroundColor }
		set(newcol)	{
			coreView.backgroundColor = newcol
			super.backgroundColor = newcol
		}
	}
	#endif

	public var font: CNFont {
		get		{ return coreView.font		}
		set(newcol)	{ coreView.font = newcol	}
	}
	
	private func setupContext(){
		guard let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTextViewCore") as? KCTextViewCore else {
			NSLog("Failed to load resource")
			return
		}
		setCoreView(view: newview)
		newview.setup(mode: .console, frame: self.frame)
		allocateSubviewLayout(subView: newview)

		/* Connect with preference */
		let pref = CNPreference.shared.terminalPreference
		mTextColorListener = pref.addObserver(forKey: pref.TextColorItem, callback: {
			(_ anyobj: Any) -> Void in
			if let color = anyobj as? KCColor {
				NSLog("update text color")
				self.textColor = color
			}
		})
		mBackgroundColorListner = pref.addObserver(forKey: pref.BackgroundColorItem, callback: {
			(_ anyobj: Any) -> Void in
			if let color = anyobj as? KCColor {
				NSLog("update background color")
				self.backgroundColor = color
			}
		})
	}

	public var fontPointSize: CGFloat{
		get		{ return coreView.fontPointSize		}
		set(newsize)	{ coreView.fontPointSize = newsize	}
	}

	public var columnNumbers: Int {
		get { return coreView.columnNumbers }
	}

	public var lineNumbers: Int {
		get { return coreView.lineNumbers }
	}

	public var minimumColumnNumbers: Int {
		get { return coreView.minimumColumnNumbers }
		set(newnum){ coreView.minimumColumnNumbers = newnum }
	}

	public var minimumLineNumbers: Int {
		get { return coreView.minimumLineNumbers }
		set(newnum){ coreView.minimumLineNumbers = newnum }
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.Low, .Low)
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(terminalView: self)
	}

	private var coreView: KCTextViewCore {
		get { return getCoreView() }
	}
}


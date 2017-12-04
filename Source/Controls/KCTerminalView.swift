/**
 * @file	 KCTermnialView.swift
 * @brief Define KCterminalView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import Canary

open class KCTerminalView : KCCoreView
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

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 270)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 22)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCTerminalView.self, nibName: "KCTerminalViewCore") as? KCTerminalViewCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
			setPriorityToResistAutoResize(holizontalPriority: .LowPriority, verticalPriority: .LowPriority)
		} else {
			fatalError("Can not load KCTerminalViewCore")
		}
	}

	public var editor: KCTextViewDelegate? {
		get { return coreView.editor}
		set(editor) { return coreView.editor = editor }
	}

	public func editStorage(editor edit: (_ storage: NSTextStorage) -> Void) {
		coreView.editStorage(editor: edit)
	}

	public var size: KCTerminalSize {
		get { return coreView.size }
	}
	
	private var coreView: KCTerminalViewCore {
		get { return getCoreView() }
	}

	open override func insertText(_ obj: Any) {
		if let str = obj as? NSString {
			Swift.print("intertText1: \(str)")
		} else if let astr = obj as? NSAttributedString {
			Swift.print("intertText2: \(astr.string)")
		} else {
			NSLog("Unknown object: \(obj)")
		}
	}
}
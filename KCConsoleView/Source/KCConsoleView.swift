/**
 * @file		KCConsoleView.h
 * @brief	Define KCConsoleView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import Canary
import KCControls

public class KCConsoleView : KCView
{
	var textView	: KCConsoleTextView? = nil ;
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let tview = loadChildXib(KCConsoleView.self, nibname: "KCConsoleTextView") as? KCConsoleTextView {
			textView = tview ;
		} else {
			fatalError("Can not load KCConsoleTextView")
		}
	}
	
	public var defaultAttribute : Dictionary<String, AnyObject> {
		get {
			if let tview = textView {
				return tview.defaultAttribute
			} else {
				fatalError("Text view must be instatiated")
			}
		}
	}
	
	public var fontSize: CGFloat {
		get {
			if let view = textView {
				return view.fontSize
			} else {
				return 0.0
			}
		}
		set(size){
			if let view = textView {
				view.fontSize = size
			}
		}
	}
	
	public var foregroundColor: NSColor? {
		get {
			if let view = textView {
				return view.foregroundColor
			} else {
				return nil
			}
		}
		set(color){
			if let view = textView {
				view.foregroundColor = color
			}
		}
	}
	
	public var backgroundColor: NSColor? {
		get {
			if let view = textView {
				return view.backgroundColor
			} else {
				return nil
			}
		}
		set(color){
			if let view = textView {
				view.backgroundColor = color
			}
		}
	}
	
	public func appendText(text : CNConsoleText){
		if let tview = textView {
			dispatch_async(dispatch_get_main_queue(), {
				tview.appendText(text)
			})
		}
	}
}



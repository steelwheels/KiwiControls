/**
 * @file		KCConsoleView.h
 * @brief	Define KCConsoleView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import Canary

public class KCConsoleView : NSView
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
		if let tview = loadChildXib(KCConsoleTextView.self, nibname: "KCConsoleTextView") {
			textView = tview ;
		} else {
			textView = nil ;
		}
	}
	
	public func loadChildXib(thisclass : AnyClass, nibname : String) -> KCConsoleTextView? {
		let bundle : NSBundle = NSBundle(forClass: thisclass) ;
		let nibp : NSNib? = NSNib(nibNamed: nibname, bundle: bundle) ;
		if let nib = nibp {
			var viewsp : NSArray? ;
			if(nib.instantiateWithOwner(nil, topLevelObjects: &viewsp)){
				if let views = viewsp {
					for (var i = 0; i < views.count; i++) {
						if let view = views[i] as? KCConsoleTextView {
							view.frame = self.bounds ;
							addSubview(view) ;
							return view ;
						}
					}
				}
			}
		}
		NSLog("Failed to load " + nibname)
		return nil ;
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



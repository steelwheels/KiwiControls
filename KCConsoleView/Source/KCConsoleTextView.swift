/**
 * @file		KCConsoleTextView.h
 * @brief	Define KCConsoleTextView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCConsoleTextView : NSView
{
	@IBOutlet var	textView: NSTextView!
	private var	mDefaultAttribute : Dictionary<String, AnyObject> = [:]
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
		
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}
	
	public var defaultAttribute : Dictionary<String, AnyObject>{
		get { return mDefaultAttribute }
	}
	
	internal func setupContext(){
		if let font = NSFont(name: "Courier New", size: 14) {
			mDefaultAttribute[NSFontAttributeName] = font
		}
		mDefaultAttribute[NSForegroundColorAttributeName] = NSColor.greenColor() ;
		mDefaultAttribute[NSBackgroundColorAttributeName] = NSColor.blackColor() ;
	}
	
	public func appendText(text : String){
		appendTextWithAttributes(text, attribute: mDefaultAttribute)
	}
	
	public func appendTextWithAttributes(text : String, attribute: Dictionary<String, AnyObject>){
		let attrstr = NSMutableAttributedString(string: text) ;
		let range = NSMakeRange(0, text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
		attrstr.setAttributes(attribute, range: range)
		appendAttributedText(attrstr)
	}
	
	public func appendAttributedText(text : NSAttributedString){
		if let tview = textView {
			if let storage = tview.textStorage {
				storage.beginEditing() ;
				storage.appendAttributedString(text) ;
				storage.endEditing() ;
				tview.scrollToEndOfDocument(self) ;
			}
		}
	}
} ;


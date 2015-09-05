/**
 * @file		KCConsoleTextView.h
 * @brief	Define KCConsoleTextView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCConsoleTextView : NSView
{
	@IBOutlet var textView: NSTextView!
	private var textAttribute : Dictionary<String, AnyObject> = [:]
	
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
		
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}
	
	internal func setupContext(){
		if let font = NSFont(name: "Courier New", size: 16) {
			textAttribute[NSFontAttributeName] = font
		}
		textAttribute[NSForegroundColorAttributeName] = NSColor.greenColor() ;
		textAttribute[NSBackgroundColorAttributeName] = NSColor.blackColor() ;
	}
	
	public func appendText(text : String){
		if let tview = textView {
			if let storage = tview.textStorage {
				storage.beginEditing() ;
				
				let attrstr = NSMutableAttributedString(string: text) ;
				let range = NSMakeRange(0, text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
				attrstr.setAttributes(textAttribute, range: range)
				
				storage.appendAttributedString(attrstr) ;
				storage.endEditing() ;
				tview.scrollToEndOfDocument(self) ;
			}
		}
	}
} ;


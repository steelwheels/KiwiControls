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

	public func appendText(text : String){
		if let tview = textView {
			if let storage = tview.textStorage {
				storage.beginEditing() ;
				  var attrstr = NSAttributedString(string: text) ;
				  storage.appendAttributedString(attrstr) ;
				storage.endEditing() ;
				tview.scrollToEndOfDocument(self) ;
			}
		}
	}
} ;


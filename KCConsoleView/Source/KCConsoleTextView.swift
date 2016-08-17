/**
 * @file		KCConsoleTextView.h
 * @brief	Define KCConsoleTextView class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import Canary
import KCControls

public class KCConsoleTextView : KCView
{
	@IBOutlet var	textView: NSTextView!
	private var	mDefaultAttribute : Dictionary<String, AnyObject> = [:]
	private	var	mFontSize : CGFloat = 14.0
	
	public override init(frame f: NSRect){
		super.init(frame: f) ;
		setupContext() ;
		
	}
	
	public required init?(coder c: NSCoder) {
		super.init(coder: c) ;
		setupContext() ;
	}
	
	public var defaultAttribute : Dictionary<String, AnyObject>{
		get { return mDefaultAttribute }
	}
	
	internal func setupContext(){
		if let font = NSFont(name: "Courier New", size: mFontSize) {
			mDefaultAttribute[NSFontAttributeName] = font
		}
		mDefaultAttribute[NSForegroundColorAttributeName] = NSColor.greenColor() ;
		mDefaultAttribute[NSBackgroundColorAttributeName] = NSColor.blackColor() ;
	}

	public var fontSize: CGFloat {
		get {
			return mFontSize ;
		}
		set(size){
			if let font = NSFont(name: "Courier New", size: size) {
				mFontSize = size
				mDefaultAttribute[NSFontAttributeName] = font
			}
		}
	}
	
	public var foregroundColor: NSColor? {
		get {
			if let color = mDefaultAttribute[NSForegroundColorAttributeName] as? NSColor {
				return color
			} else {
				return nil
			}
		}
		set(color){
			mDefaultAttribute[NSForegroundColorAttributeName] = color
		}
	}
	
	public var backgroundColor: NSColor? {
		get {
			if let color = mDefaultAttribute[NSBackgroundColorAttributeName] as? NSColor {
				return color
			} else {
				return nil
			}
		}
		set(color){
			mDefaultAttribute[NSBackgroundColorAttributeName] = color
		}
	}
	
	public func append(text t: CNConsoleText){
		dispatch_async(dispatch_get_main_queue(), {
			for word in t.words {
				self.append(word: word)
			}
		})
	}
	
	private func append(word w: CNConsoleWord){
		let attrs  = mergeAttributes(word: w)
		let newstr = NSAttributedString(string: w.string, attributes: attrs)
		appendAttributedText(attributedString: newstr)
	}
	
	private func mergeAttributes(word w: CNConsoleWord) -> Dictionary<String, AnyObject> {
		var info = mDefaultAttribute
		for (key, value) in w.attributes {
			info[key] = value
		}
		return info
	}
	
	private func appendAttributedText(attributedString s: NSAttributedString){
		if let tview = textView {
			if let storage = tview.textStorage {
				storage.beginEditing() ;
				storage.appendAttributedString(s) ;
				storage.endEditing() ;
				tview.scrollToEndOfDocument(self) ;
			}
		}
	}
} ;


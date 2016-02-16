/**
 * @file	KCTextField.h
 * @brief	Extend NSTextField class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Cocoa

public class KCTextFieldDelegate : NSObject, NSTextFieldDelegate
{
	public var textDidChangeCallback : ((text: String) -> Void)?	= nil
	
	public override func controlTextDidChange(notification: NSNotification) {
		if let textfield = notification.object as? NSTextField {
			if let callback = textDidChangeCallback {
				/* Call callback method */
				callback(text: textfield.stringValue)
			}
		} else {
			fatalError("Unknown sender")
		}
	}
}



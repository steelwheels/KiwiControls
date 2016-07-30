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
	public var textDidChangeCallback : ((textField:NSTextField, text: String) -> Void)?	= nil
	
	public override func controlTextDidChange(notification: NSNotification) {
		if let textfield = notification.object as? NSTextField {
			if let callback = textDidChangeCallback {
				/* Call callback method */
				callback(textField: textfield, text: textfield.stringValue)
			}
		} else {
			fatalError("Unknown sender")
		}
	}
}

public enum KCFieldFormat {
	case TextFormat
	case IntegerFormat
}

public class KCFormattedTextFieldDelegate: KCTextFieldDelegate
{
	public var fieldFormat: KCFieldFormat = .TextFormat

	public override func controlTextDidChange(notification: NSNotification) {
		if let textfield = notification.object as? NSTextField {
			if checkString(textfield.stringValue){
				textfield.textColor = NSColor.blackColor()
				if let callback = textDidChangeCallback {
					/* Call callback method */
					callback(textField: textfield, text: textfield.stringValue)
				}
			} else {
				textfield.textColor = NSColor.redColor()
			}
		} else {
			fatalError("Unknown sender")
		}
	}

	public func checkString(text: String) -> Bool {
		var result = false
		switch fieldFormat {
		case .TextFormat:
			result = true
		case .IntegerFormat:
			if let _ = Int(text) {
				result = true
			}
		}
		return result
	}
}


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
	
	public func control(control: NSControl, isValidObject obj: AnyObject) -> Bool {
		var result = false
		if let text = obj as? String {
			result = checkString(text)
		} else if let str = obj as? NSString {
			result = checkString(str as String)
		} else if let _ = obj as? NSNumber {
			result = true
		}
		return result
	}
	
	public func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		if let str = fieldEditor.string {
			return checkString(str)
		} else {
			return false
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


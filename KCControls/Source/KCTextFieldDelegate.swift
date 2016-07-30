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

public enum KCFieldFormat {
	case TextFormat
	case IntegerFormat
}

public class KCFormattedTextFieldDelegate: KCTextFieldDelegate
{
	public  var fieldFormat:		KCFieldFormat = .TextFormat
	private var ownerTextField:		NSTextField?  = nil

	public override func controlTextDidChange(notification: NSNotification) {
		if let textfield = notification.object as? NSTextField {
			ownerTextField = textfield
			if checkString(textfield.stringValue){
				textfield.textColor = NSColor.blackColor()
			} else {
				textfield.textColor = NSColor.redColor()
			}
		} else {
			fatalError("Unknown sender")
		}
	}

	public func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		if let str = fieldEditor.string {
			if checkString(str) {
				if let callback = textDidChangeCallback, textfield = ownerTextField {
					/* Call callback method */
					callback(text: textfield.stringValue)
				}
			}
		}
		return true
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


/**
 * @file	KCTextField.h
 * @brief	Extend NSTextField class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Cocoa

public class KCTextFieldDelegate: NSObject, NSTextFieldDelegate {
	public var textDidChangeCallback: ((value: String, tag:Int) -> Void)? = nil

	public func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		if let textfield = control as? NSTextField, let str = fieldEditor.string {
			if let callback = textDidChangeCallback {
				callback(value: str, tag: textfield.tag)
			}
		}
		return true
	}
}

public class KCIntegerFieldDelegate: NSObject, NSTextFieldDelegate {
	public var valueDidChangeCallback: ((value:Int, tag:Int) -> Void)? = nil

	public override func controlTextDidChange(notification: NSNotification) {
		if let textfield = notification.object as? NSTextField {
			if let _ = Int(textfield.stringValue) {
				textfield.textColor = NSColor.blackColor()
			} else {
				textfield.textColor = NSColor.redColor()
			}
		} else {
			fatalError("Unknown sender")
		}
	}

	public func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		if let textfield = control as? NSTextField, let str = fieldEditor.string {
			if let value = Int(str), callback = valueDidChangeCallback {
				callback(value: value, tag: textfield.tag)
			}
		}
		return true
	}
}


/**
 * @file	KCTextField.h
 * @brief	Extend NSTextField class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif

#if os(OSX)

public class KCTextFieldDelegate: NSObject, NSTextFieldDelegate {
	public var textDidChangeCallback: ((_: String, _:Int) -> Void)? = nil

	public func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		if let textfield = control as? NSTextField, let str = fieldEditor.string {
			if let callback = textDidChangeCallback {
				callback(str, textfield.tag)
			}
		}
		return true
	}
}

public class KCIntegerFieldDelegate: NSObject, NSTextFieldDelegate {
	public var valueDidChangeCallback: ((_ value:Int,_ tag:Int) -> Void)? = nil

	public override func controlTextDidChange(_ notification: Notification) {
		if let textfield = notification.object as? NSTextField {
			if let _ = Int(textfield.stringValue) {
				textfield.textColor = NSColor.black
			} else {
				textfield.textColor = NSColor.red
			}
		} else {
			fatalError("Unknown sender")
		}
	}

	public func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
		if let textfield = control as? NSTextField, let str = fieldEditor.string {
			if let value = Int(str), let callback = valueDidChangeCallback {
				callback(value, textfield.tag)
			}
		}
		return true
	}
}

#endif



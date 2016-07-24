/**
 * @file	KCFormattedTextField.swift
 * @brief	Define KCFormattedTextField class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import Cocoa

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

public class KCFormattedTextField: NSTextField
{
	private var mDelegate = KCFormattedTextFieldDelegate()
	
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.delegate = mDelegate
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.delegate = mDelegate
	}
	
	public var fieldFormat: KCFieldFormat {
		set(format){	mDelegate.fieldFormat = format	}
		get {		return mDelegate.fieldFormat	}
	}
	
	public var textDidChangeCallback : ((text: String) -> Void)? {
		set(callback){	mDelegate.textDidChangeCallback = callback	}
		get {		return mDelegate.textDidChangeCallback		}
	}
	
	public var hasValidValue: Bool {
		get { return mDelegate.checkString(self.stringValue) }
	}
}

public class KCIntegerTextField: KCFormattedTextField
{
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		self.fieldFormat = .IntegerFormat
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.fieldFormat = .IntegerFormat
	}
}


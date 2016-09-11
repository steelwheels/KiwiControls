/**
 * @file	KCTableView.h
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Cocoa

public class KCTableView: NSTableView
{
	public override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
		//Swift.print("validate")
		if let textfield = responder as? NSTextField {
			return textfield.isEditable
		}
		return super.validateProposedFirstResponder(responder, for: event)
	}
}


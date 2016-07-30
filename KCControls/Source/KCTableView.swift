/**
 * @file	KCTableView.h
 * @brief	Define KCTableView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Cocoa

public class KCTableView: NSTableView
{
	public override func validateProposedFirstResponder(responder: NSResponder, forEvent event: NSEvent?) -> Bool {
		//Swift.print("validate")
		if let textfield = responder as? NSTextField {
			return textfield.editable
		}
		return super.validateProposedFirstResponder(responder, forEvent: event)
	}
}


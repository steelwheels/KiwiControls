//
//  UTTableDelegate.swift
//  KCControls
//
//  Created by Tomoo Hamada on 2016/07/27.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCControls

public class UTTableDelegate: NSObject, NSTableViewDelegate
{
	private var mTextFieldDelegate = KCFormattedTextFieldDelegate()
	
	public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		mTextFieldDelegate.fieldFormat = .IntegerFormat
		mTextFieldDelegate.textDidChangeCallback = {
			(text: String) -> Void in
			Swift.print("UTTableDelegate: textDidChange: text=\(text)")
		}

		let textfield = NSTextField()
		textfield.delegate = mTextFieldDelegate
		textfield.bordered = false
		return textfield
	}
}

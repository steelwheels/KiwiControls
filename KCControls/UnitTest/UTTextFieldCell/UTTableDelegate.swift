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
	private var mIntegerFieldDelegate: KCIntegerFieldDelegate? = nil

	private func integerFieldDelegate() -> KCIntegerFieldDelegate {
		if let delegate = mIntegerFieldDelegate {
			return delegate
		} else {
			let newdelegate = KCIntegerFieldDelegate()
			newdelegate.valueDidChangeCallback = {
				(value: Int, tag: Int) -> Void in
				Swift.print("valueDidChange: tag=\(tag) value=\(value)")
			}

			mIntegerFieldDelegate = newdelegate
			return newdelegate
		}
	}
	
	public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let textfield = NSTextField()
		textfield.tag	   = row
		textfield.delegate = integerFieldDelegate()
		textfield.bordered = false
		return textfield
	}
}

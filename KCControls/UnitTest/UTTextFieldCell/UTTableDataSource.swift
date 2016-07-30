//
//  UTTableDataSource.swift
//  KCControls
//
//  Created by Tomoo Hamada on 2016/07/27.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa

public class UTTableDataSource: NSObject, NSTableViewDataSource
{
	public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return 5
	}

	public func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
		return String(format: "%u", row)
	}

	public func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
	}
}


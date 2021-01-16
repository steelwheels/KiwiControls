/**
 * @file	KCTableDataSource.m
 * @brief	Define KCTableDataSource class
 * @par Copyright
 *   Copyright (C) 2021 Steel Wheels Project
 * @par Reference
 */

import CoconutData
import Foundation
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

#if os(OSX)
typealias KCTableViewDataSourceProtocol = NSTableViewDataSource
#else
typealias KCTableViewDataSourceProtocol = UITableViewDataSource
#endif

@objc public class KCTableDataSource: NSObject, KCTableViewDataSourceProtocol
{
	private var mTableData:		CNTableData

	public init(tableData tdata: CNTableData) {
		mTableData = tdata
	}

	#if os(OSX)
	public func numberOfRows(in tableView: NSTableView) -> Int {
		NSLog("tableView (0): \(mTableData.numberOfRows)")
		return mTableData.numberOfRows
	}

	#else
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		return cell
	}
	#endif
}


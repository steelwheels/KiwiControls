//
//  ViewController.swift
//  UTTable
//
//  Created by Tomoo Hamada on 2021/05/14.
//

import KiwiControls
import CoconutData
import Cocoa

public class UTTableData: KCTableDelegate
{
	let ROW_NUM = 2
	let COL_NUM = 2

	private var mData:	Array<Array<CNNativeValue>>

	public init() {
		mData = []
		for c in 0..<COL_NUM {
			var col: Array<CNNativeValue> = []
			for r in 0..<ROW_NUM {
				let value: CNNativeValue = .stringValue("\(c)/\(r)")
				col.append(value)
			}
			mData.append(col)
		}
	}

	public var columnCount: Int { get { return COL_NUM }}
	public var rowCount:    Int { get { return ROW_NUM }}

	public func title(column index: Int) -> String {
		return "_\(index)"
	}

	public func set(colmunName cname: String, rowIndex ridx: Int, data dat: Any?) {
		NSLog("UTTableData: Set: \(cname) \(ridx)")
	}

	public func view(colmunName cname: String, rowIndex ridx: Int) -> KCView? {
		NSLog("UTTableData: View: name=\(cname) \(ridx)")
		let view  = KCTextEdit()
		view.text = "\(cname)/\(ridx)"
		NSLog(" -> view size (0): \(view.frame.size)")
		let size  = view.fittingSize
		view.setFrameSize(size)
		NSLog(" -> view size (1): \(view.frame.size)")
		return view
	}

	public func view(colmunIndex cidx: Int, rowIndex ridx: Int) -> KCView? {
		NSLog("UTTableData: View: cidx=\(cidx) \(ridx)")
		let view  = KCTextEdit()
		view.text = "\(cidx)/\(ridx)"
		NSLog(" -> view size (0): \(view.frame.size)")
		let size  = view.fittingSize
		view.setFrameSize(size)
		NSLog(" -> view size (1): \(view.frame.size)")
		return view
	}
}

class ViewController: NSViewController
{
	@IBOutlet weak var mTableView: KCTableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		mTableView.tableDelegate = UTTableData()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


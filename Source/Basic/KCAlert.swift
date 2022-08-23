/**
 * @file	KCAlert.swift
 * @brief	Define KCAlert class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import CoconutData

public class KCAlert : NSObject
{
	public class func alert(type typ: CNAlertType, messgage msg: String, in viewcont: KCViewController, callback cbfunc: @escaping (_ buttonid: Int) -> Void) {
		#if os(OSX)
			let alert = NSAlert()
			switch typ {
			  case .critical:	alert.alertStyle = .critical
			  case .informational:	alert.alertStyle = .informational
			  case .warning:	alert.alertStyle = .warning
			}
			alert.messageText = msg
			alert.addButton(withTitle: "OK")
			switch alert.runModal() {
			  case .alertFirstButtonReturn:		cbfunc(0)
			  case .alertSecondButtonReturn:	cbfunc(1)
			  case .alertThirdButtonReturn:		cbfunc(2)
			  default:				cbfunc(-1)
			}
		#else
			let title   = "Error"
			let alert   = UIAlertController(title: title, message: msg, preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default, handler: {
				(action:UIAlertAction!) -> Void in
			})
			alert.addAction(action)
			viewcont.present(alert, animated: false, completion: {
				() -> Void in
				cbfunc(0)
			})
		#endif
	}
}


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
	public enum AlertType {
		case	error
		case	information
	}

	public enum SaveResponce {
		case Save
		case Cancel
		case DontSave
	}

	public class func alert(type typ: AlertType, messgage msg: String, in viewcont: KCViewController, callback cbfunc: @escaping (_ buttonid: Int) -> Void) {
		#if os(OSX)
			let alert = NSAlert()
			switch typ {
			  case .error:		alert.alertStyle = .critical
			  case .information:	alert.alertStyle = .informational
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

/*
	#if os(OSX)
	public class func alert(error err: NSError, in viewcont: NSViewController, callback cbfunc: @escaping (_ buttonid: Int) -> Void) {
		let alert = NSAlert(error: err)
		alert.alertStyle = codeToStyle(error: err)
		switch alert.runModal() {
		case .alertFirstButtonReturn:	cbfunc(0)
		case .alertSecondButtonReturn:	cbfunc(1)
		case .alertThirdButtonReturn:	cbfunc(2)
		default:			cbfunc(-1)
		}
	}

	private class func codeToStyle(error err: NSError) -> NSAlert.Style {
		let style: NSAlert.Style
		switch err.errorCode {
		case .Information:
			style = .informational
		case .InternalError, .ParseError, .FileError, .SerializeError, .UnknownError:
			style = .critical
		@unknown default:
			CNLog(logLevel: .error, message: "Unknown error code")
			style = .critical
		}
		return style
	}
	#else
	public class func alert(error err: NSError, in viewcont: UIViewController, callback cbfunc: @escaping (_ buttonid: Int) -> Void) {
		let title   = "Error"
		let message = err.toString()
		let alert   = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: {
			(action:UIAlertAction!) -> Void in
		})
		alert.addAction(action)
		viewcont.present(alert, animated: false, completion: {
			() -> Void in
			cbfunc(0)
		})
	}
	#endif
*/

	#if false
	public class func recommendSaveModal(fileName fname: String) -> SaveResponce
	{
		let alert = NSAlert()
		alert.messageText = "\(fname) has changes. Do you want to save it"
		alert.informativeText = "Your changes will be lost if you close this item without saving."
		alert.addButton(withTitle: "Save")
		alert.addButton(withTitle: "Cancel")
		alert.addButton(withTitle: "Don't save")

		var result : SaveResponce
		switch alert.runModal() {
		case NSApplication.ModalResponse.alertFirstButtonReturn:
			result = .Save
		case NSApplication.ModalResponse.alertSecondButtonReturn:
			result = .Cancel
		case NSApplication.ModalResponse.alertThirdButtonReturn:
			result = .DontSave
		default:
			result = .Cancel
		}
		return result
	}
	#endif
}


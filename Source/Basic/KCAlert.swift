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
	public enum AlertResponce {
		case OK
		case Cancel
	}

	public enum SaveResponce {
		case Save
		case Cancel
		case DontSave
	}

	#if os(OSX)
	public class func runModal(error err: NSError, in viewcont: NSViewController) -> AlertResponce
	{
		var result: AlertResponce
		let alert = NSAlert(error: err)
		alert.alertStyle = codeToStyle(error: err)
		switch alert.runModal() {
		case .OK:
			result = .OK
		case .cancel:
			result = .Cancel
		default:
			result = .Cancel
		}
		return result
	}

	private class func codeToStyle(error err: NSError) -> NSAlert.Style {
		let style: NSAlert.Style
		switch err.errorCode {
		case .Information:
			style = .informational
		case .InternalError, .ParseError, .FileError, .SerializeError, .UnknownError:
			style = .critical
		}
		return style
	}

	#else
	public class func runModal(error err: NSError, in viewcont: UIViewController) -> AlertResponce
	{
		let title   = "Error"
		let message = err.toString()
		let alert   = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let acttion = UIAlertAction(title: "OK", style: .default, handler: {
			(action:UIAlertAction!) -> Void in
			/* Do nothing */
		})
		alert.addAction(acttion)
		viewcont.present(alert, animated: false, completion: nil)
		return .Cancel
	}
	#endif

	#if os(OSX)
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


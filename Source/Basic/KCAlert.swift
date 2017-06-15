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

public class KCAlert : NSObject
{
	public enum AlertResponce {
		case Stop
		case Abort
		case Continue
	}

	public enum SaveResponce {
		case Save
		case Cancel
		case DontSave
	}

	#if os(OSX)
	public class func runModal(error err: NSError) -> AlertResponce
	{
		var result: AlertResponce
		let alert = NSAlert(error: err)
		switch alert.runModal() {
		case NSModalResponceStop:
			result = .Stop
		case NSModalResporceAbort:
			result = .Abort
		case NSModalResporceContinue:
			result = .Continue
		}
		return result
	}
	#else
	public class func runModal(error err: NSError, in viewcont: UIViewController) -> AlertResponce
	{
		let title   = "Error"
		let message = err.description
		let alert   = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let acttion = UIAlertAction(title: "OK", style: .default, handler: {
			(action:UIAlertAction!) -> Void in
		})
		alert.addAction(acttion)
		viewcont.present(alert, animated: false, completion: nil)
		return .Stop
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

		var result : SaveModalResponce
		switch alert.runModal() {
		case NSAlertFirstButtonReturn:
			result = .SaveButtonPressed
		case NSAlertSecondButtonReturn:
			result = .CancelButtonPressed
		case NSAlertThirdButtonReturn:
			result = .DontSaveButtonPressed
		default:
			result = .CancelButtonPressed
		}
		return result
	}
	#endif
}


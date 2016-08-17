/**
 * @file	KCAlert.h
 * @brief	Define KCAlert class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCAlert : NSObject {
	public class func runModal(error err: NSError) -> NSModalResponse {
		let alert = NSAlert(error: err)
		return alert.runModal()
	}
	
	public enum SaveModalResponce {
		case SaveButtonPressed
		case CancelButtonPressed
		case DontSaveButtonPressed
	}
	
	public class func recommendSaveModal(fileName fname: String) -> SaveModalResponce {
		let alert = NSAlert()
		alert.messageText = "\(fname) has changes. Do you want to save it"
		alert.informativeText = "Your changes will be lost if you close this item without saving."
		alert.addButtonWithTitle("Save")
		alert.addButtonWithTitle("Cancel")
		alert.addButtonWithTitle("Don't save")
		
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
}


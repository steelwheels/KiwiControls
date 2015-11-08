/**
 * @file	KCAlert.h
 * @brief	Define KCAlert class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCAlert : NSObject {
	public class func runModal(error : NSError) -> NSModalResponse {
		let alert = NSAlert(error: error)
		return alert.runModal()
	}
}


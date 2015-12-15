/**
 * @file	KCOpenPanel.h
 * @brief	Define KCOpenPanel class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation
import Cocoa

public class KCOpenPanel {
	public func homeDirectoryWithAcccessControl() -> NSOpenPanel {
		let panel = NSOpenPanel()
		panel.directoryURL = NSURL(string: NSHomeDirectory())
		panel.delegate = KCOpenSavePanelDelegate()
		panel.canChooseDirectories = false
		return panel
	}
}

enum KCOpenSavePanelError : ErrorType {
	case InvalidURL
}

internal class KCOpenSavePanelDelegate : NSObject, NSOpenSavePanelDelegate {
	internal func panel(sender: AnyObject, shouldEnableURL url: NSURL) -> Bool {
		if let srcpath  = url.path {
			let homepath = NSHomeDirectory()
			return srcpath.hasPrefix(homepath) && !(srcpath == homepath)
		}
		return false
	}
	
	internal func panel(sender: AnyObject, didChangeToDirectoryURL url: NSURL?) {
		if let url = url, srcpath  = url.path {
			let homepath = NSHomeDirectory()
			if(!srcpath.hasPrefix(homepath)) {
				if let panel = sender as? NSOpenPanel {
					panel.directoryURL = NSURL(string: homepath)
				}
			}
		}
	}
	
	func panel(sender: AnyObject, validateURL url: NSURL) throws {
		if let srcpath  = url.path {
			let homepath = NSHomeDirectory()
			if(srcpath.hasPrefix(homepath)) {
				return
			}
		}
		throw KCOpenSavePanelError.InvalidURL
	}
}

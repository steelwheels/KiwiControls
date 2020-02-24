/**
 * @file	KCPreferenceWindow.swift
 * @brief	Define KCPreferenceWindow class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 * @references
 *   https://genjiapp.com/blog/2012/10/25/how-to-develop-a-preferences-window-for-os-x-app.html (Japanese)
 */

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import Foundation

#if os(OSX)

public class KCPreferenceWindow: NSWindow
{
	/* Close the window when the ESC is pressed */
	public override func cancelOperation(_ sender: Any?) {
		self.close()
	}
}

#endif // os(OSX)


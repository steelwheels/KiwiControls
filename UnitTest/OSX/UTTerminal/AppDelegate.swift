//
//  AppDelegate.swift
//  UTTerminal
//
//  Created by Tomoo Hamada on 2019/08/11.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
	func applicationWillFinishLaunching(_ notification: Notification) {
		UserDefaults.standard.applyDefaultSetting()
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}


//
//  AppDelegate.swift
//  UTTerminal
//
//  Created by Tomoo Hamada on 2019/08/11.
//  Copyright © 2019 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import Cocoa

@NSApplicationMain
class AppDelegate: KCApplicationDelegate
{
	open override func applicationWillFinishLaunching(_ notification: Notification) {
		NSLog("applicationWillFinishLaunching")
		UserDefaults.standard.applyDefaultSetting()
	}

	open override func applicationDidFinishLaunching(_ aNotification: Notification) {
		super.applicationDidFinishLaunching(aNotification)
		NSLog("applicationDidFinishLaunching")
	}

	open override func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}


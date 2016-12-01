/**
 * @file	KCTimerViewCore.swift
 * @brief	Define KCTimerViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#endif

open class KCTimerViewCore : KCView
{
	@IBOutlet weak var mTextField: NSTextField!

}

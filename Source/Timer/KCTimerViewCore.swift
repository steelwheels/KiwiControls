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

	var mTimerValue: TimeInterval? = 0.0

	public var timerValue: TimeInterval? {
		get {
			return mTimerValue
		}
		set(newval){
			var valstr: NSString
			if let val = newval {
				valstr = NSString(format: "%.2lf", val)
			} else {
				valstr = ""
			}
			mTimerValue = newval
			DispatchQueue.main.async(execute: {
				self.mTextField.stringValue = valstr as String
			})
		}
	}
}

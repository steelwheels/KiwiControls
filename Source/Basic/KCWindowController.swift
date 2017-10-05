/**
 * @file	KCWindowController.swift
 * @brief	Define KCWindowController class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import AppKit
import Foundation

open class KCWindowController: NSWindowController
{
	public init(){
		if let window = KCWindowController.loadNibFile() {
			super.init(window: window)
		} else {
			fatalError("Failed to init")
		}
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private class func loadNibFile() -> KCWindow?
	{
		let bundle  = Bundle(for: KCWindow.self) ;
		if let nib     = NSNib(nibNamed: NSNib.Name(rawValue: "KCWindow"), bundle: bundle){
			var windowsp : NSArray? = NSArray()
			if nib.instantiate(withOwner: nil, topLevelObjects: &windowsp) {
				if let windows = windowsp {
					for window in windows {
						if let result = window as? KCWindow {
							return result
						}
					}
				}
			}
		}
		return nil
	}
}


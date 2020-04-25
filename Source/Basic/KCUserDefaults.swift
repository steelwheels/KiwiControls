/**
 * @file	KCUserDefaults.swift
 * @brief	Define KCUserDefaults class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import CoconutData
import Foundation

extension UserDefaults
{
	/* Apply default setting. This method will be called from
	 * "applicationWillFinishLaunching" method on AppDelegate object
	 */
	public func applyDefaultSetting() {
		self.set(true, forKey: "NSDisabledDictationMenuItem")
		self.set(true, forKey: "NSDisabledCharacterPaletteMenuItem")
	}

	public func color(forKey key: String) -> CNColor? {
		if let data = self.data(forKey: key) {
			return CNColor.decode(fromData: data)
		} else {
			return nil
		}
	}

	public func set(color col: CNColor, forKey key: String) {
		if let data = col.toData() {
			set(data, forKey: key)
		} else {
			NSLog("\(#file): Failed to encode color")
		}
	}
}

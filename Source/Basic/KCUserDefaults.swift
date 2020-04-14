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
		do {
			if let data = self.data(forKey: key) {
				if let color = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [CNColor.self], from: data) as? CNColor {
					return color
				}
			}
		}
		catch let err as NSError {
			NSLog("\(err.description)")
		}
		return nil
	}

	public func set(color colobj: CNColor, forKey key: String) {
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: colobj, requiringSecureCoding: false)
			set(data, forKey: key)
		}
		catch let err as NSError {
			NSLog("\(err.description)")
		}
	}
}
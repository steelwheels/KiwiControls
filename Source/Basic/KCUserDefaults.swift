/**
 * @file	KCUserDefaults.swift
 * @brief	Define KCUserDefaults class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

import Foundation

extension UserDefaults
{
	public func color(forKey key: String) -> KCColor? {
		do {
			if let data = self.data(forKey: key) {
				if let color = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [KCColor.self], from: data) as? KCColor {
					return color
				}
			}
		}
		catch let err as NSError {
			NSLog("\(err.description)")
		}
		return nil
	}

	public func set(color colobj: KCColor, forKey key: String) {
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: colobj, requiringSecureCoding: false)
			set(data, forKey: key)
		}
		catch let err as NSError {
			NSLog("\(err.description)")
		}
	}
}

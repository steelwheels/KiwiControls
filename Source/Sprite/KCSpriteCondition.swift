/**
 * @file KCSpriteCondition.swift
 * @brief Define KCSpriteCondition class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public struct KCSpriteCondition
{
	public var collisionDamage:	Double

	public init(collidionDamage cdamage: Double){
		collisionDamage = cdamage
	}

	public init(){
		collisionDamage = 0.0
	}

	public func toValue() -> CNNativeValue {
		let dict :Dictionary<String, CNNativeValue> = [
			"collisionDamage": CNNativeValue.numberValue(NSNumber(floatLiteral: collisionDamage))
		]
		return CNNativeValue.dictionaryValue(dict)
	}

	public static func spriteCondition(from value: CNNativeValue) -> KCSpriteCondition? {
		if let cdamage = value.numberProperty(identifier: "collisionDamage") {
			return KCSpriteCondition(collidionDamage: cdamage.doubleValue)
		} else {
			return nil
		}
	}
}


/**
 * @file KCSpriteCondition.swift
 * @brief Define KCSpriteNodeCondition class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public struct KCSpriteNodeCondition
{
	private static let GivingCollisionDamageItem		= "givingCollisionDamage"
	private static let ReceivingCollisionDamaggeItem	= "receivingCollisionDamage"

	public var givingCollisionDamage:	Double
	public var receivingCollisionDamage:	Double

	public init(givingCollisionDamage gcdamage: Double, receivingCollisionDamage rcdamage: Double){
		givingCollisionDamage		= gcdamage
		receivingCollisionDamage	= rcdamage
	}

	public func toValue() -> CNNativeValue {
		let dict :Dictionary<String, CNNativeValue> = [
			KCSpriteNodeCondition.GivingCollisionDamageItem: 		CNNativeValue.numberValue(NSNumber(floatLiteral: givingCollisionDamage)),
			KCSpriteNodeCondition.ReceivingCollisionDamaggeItem:	CNNativeValue.numberValue(NSNumber(floatLiteral: receivingCollisionDamage))
		]
		return CNNativeValue.dictionaryValue(dict)
	}

	public static func spriteCondition(from value: CNNativeValue) -> KCSpriteNodeCondition? {
		if let gcdamage = value.numberProperty(identifier: KCSpriteNodeCondition.GivingCollisionDamageItem),
		   let rcdamage = value.numberProperty(identifier: KCSpriteNodeCondition.ReceivingCollisionDamaggeItem) {
			return KCSpriteNodeCondition(givingCollisionDamage: gcdamage.doubleValue, receivingCollisionDamage: rcdamage.doubleValue)
		} else {
			return nil
		}
	}
}


/**
 * @file KCSpriteCondition.swift
 * @brief Define KCSpriteCondition class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteCondition
{
	private static let GivingCollisionDamageItem		= "givingCollisionDamage"
	private static let ReceivingCollisionDamaggeItem	= "receivingCollisionDamage"
	private static let RaderRangeItem			= "raderRange"

	public static let NoRange: Double	= -1.0

	public var givingCollisionDamage:	Double
	public var receivingCollisionDamage:	Double
	public var raderRange:			Double

	public init(givingCollisionDamage gcdamage: Double, receivingCollisionDamage rcdamage: Double, raderRange rrange: Double){
		givingCollisionDamage		= gcdamage
		receivingCollisionDamage	= rcdamage
		raderRange			= rrange
	}

	public func toValue() -> CNNativeValue {
		let dict :Dictionary<String, CNNativeValue> = [
			KCSpriteCondition.GivingCollisionDamageItem: 		CNNativeValue.numberValue(NSNumber(floatLiteral: givingCollisionDamage)),
			KCSpriteCondition.ReceivingCollisionDamaggeItem:	CNNativeValue.numberValue(NSNumber(floatLiteral: receivingCollisionDamage)),
			KCSpriteCondition.RaderRangeItem:			CNNativeValue.numberValue(NSNumber(floatLiteral: raderRange))
		]
		return CNNativeValue.dictionaryValue(dict)
	}

	public static func spriteCondition(from value: CNNativeValue) -> KCSpriteCondition? {
		if let gcdamage = value.numberProperty(identifier: KCSpriteCondition.GivingCollisionDamageItem),
		   let rcdamage = value.numberProperty(identifier: KCSpriteCondition.ReceivingCollisionDamaggeItem),
		   let rrange   = value.numberProperty(identifier: KCSpriteCondition.RaderRangeItem){
			return KCSpriteCondition(givingCollisionDamage: gcdamage.doubleValue, receivingCollisionDamage: rcdamage.doubleValue, raderRange: rrange.doubleValue)
		} else {
			return nil
		}
	}
}


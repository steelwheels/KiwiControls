/**
 * @file KCSpriteCondition.swift
 * @brief Define KCSpriteCondition class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteCondition: CNNativeStruct
{
	private static let GivingCollisionDamageItem		= "givingCollisionDamage"
	private static let ReceivingCollisionDamaggeItem	= "receivingCollisionDamage"
	private static let RadarRangeItem			= "radarRange"

	public static let NoRange: Double			= -1.0

	private var mGivingCollisionDamage:		Double
	private var mReceivingCollisionDamage:		Double
	private var mRadarRange:			Double

	public init(givingCollisionDamage gcdamage: Double, receivingCollisionDamage rcdamage: Double, radarRange rrange: Double){
		mGivingCollisionDamage		= gcdamage
		mReceivingCollisionDamage	= rcdamage
		mRadarRange			= rrange
		super.init(name: "SpriteCondition")

		super.setMember(name: KCSpriteCondition.GivingCollisionDamageItem, value: CNNativeValue.numberValue(NSNumber(floatLiteral: gcdamage)))
		super.setMember(name: KCSpriteCondition.ReceivingCollisionDamaggeItem, value: CNNativeValue.numberValue(NSNumber(floatLiteral: rcdamage)))
		super.setMember(name: KCSpriteCondition.RadarRangeItem, value: CNNativeValue.numberValue(NSNumber(floatLiteral: rrange)))
	}

	public var givingCollisionDamage: Double	{ get { return mGivingCollisionDamage 		}}
	public var receivingCollisionDamage: Double 	{ get { return mReceivingCollisionDamage	}}
	public var radarRange: Double			{ get { return mRadarRange 			}}

	public static func spriteCondition(from value: CNNativeValue) -> KCSpriteCondition? {
		if let gcdamage = value.numberProperty(identifier: KCSpriteCondition.GivingCollisionDamageItem),
		   let rcdamage = value.numberProperty(identifier: KCSpriteCondition.ReceivingCollisionDamaggeItem),
		   let rrange   = value.numberProperty(identifier: KCSpriteCondition.RadarRangeItem){
			return KCSpriteCondition(givingCollisionDamage: gcdamage.doubleValue, receivingCollisionDamage: rcdamage.doubleValue, radarRange: rrange.doubleValue)
		} else {
			return nil
		}
	}
}


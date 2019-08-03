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
	private static let RaderRangeItem			= "raderRange"

	public static let NoRange: Double			= -1.0

	private var mGivingCollisionDamage:		Double
	private var mReceivingCollisionDamage:		Double
	private var mRaderRange:			Double

	public init(givingCollisionDamage gcdamage: Double, receivingCollisionDamage rcdamage: Double, raderRange rrange: Double){
		mGivingCollisionDamage		= gcdamage
		mReceivingCollisionDamage	= rcdamage
		mRaderRange			= rrange
		super.init(name: "SpriteCondition")
	}

	public var givingCollisionDamage: Double	{ get { return mGivingCollisionDamage 		}}
	public var receivingCollisionDamage: Double 	{ get { return mReceivingCollisionDamage	}}
	public var radarRange: Double			{ get { return mRaderRange 			}}

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


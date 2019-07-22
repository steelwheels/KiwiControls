/**
 * @file KCSpriteStatus.swift
 * @brief Define KCSpriteNodeStatus class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public struct KCSpriteNodeStatus
{
	public static let DEFAULT_ENERGY: Double	= 1.0

	public var	name:		String
	public var	teamId:		Int
	public var	size:		CGSize
	public var 	position:	CGPoint
	public var	bounds:		CGRect
	public var	energy:		Double

	public init(name nm: String, teamId tid: Int, size sz: CGSize, position pos: CGPoint, bounds bnds: CGRect, energy engy: Double){
		name     = nm
		teamId   = tid
		size     = sz
		position = pos
		bounds   = bnds
		energy	 = engy
	}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["name"]	= CNNativeValue.stringValue(name)
		top["teamId"]	= CNNativeValue.numberValue(NSNumber(integerLiteral: teamId))
		top["size"]     = CNNativeValue.sizeValue(size)
		top["position"] = CNNativeValue.pointValue(position)
		top["bounds"]   = CNNativeValue.rectValue(bounds)
		top["energy"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: energy))
		return CNNativeValue.dictionaryValue(top)
	}

	public static func spriteNodeStatus(from value: CNNativeValue) -> KCSpriteNodeStatus? {
		if let name = value.stringProperty(identifier: "name"),
			let tid  = value.numberProperty(identifier: "teamId"),
			let size = value.sizeProperty(identifier:   "size"),
			let pos  = value.pointProperty(identifier:  "position"),
			let bnds = value.rectProperty(identifier:   "bounds"),
			let engy = value.numberProperty(identifier: "energy") {
			return KCSpriteNodeStatus(name: name, teamId: tid.intValue, size: size, position: pos, bounds: bnds, energy: engy.doubleValue)
		} else {
			return nil
		}
	}
}

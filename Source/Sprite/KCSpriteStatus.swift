/**
 * @file KCSpriteStatus.swift
 * @brief Define KCSpriteNodeStatus class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteNodeStatus: CNNativeStruct
{
	public static let DEFAULT_ENERGY: Double	= 1.0

	public static let NameItem		= "name"
	public static let TeamIdItem		= "teamId"
	public static let SizeItem		= "size"
	public static let PositionItem		= "position"
	public static let BoundsItem		= "bounds"
	public static let EnergyItem		= "energy"

	public var	mNodeName:		String
	public var	mTeamId:		Int
	public var	mSize:			CGSize
	public var 	mPosition:		CGPoint
	public var	mBounds:		CGRect
	public var	mEnergy:		Double

	public init(name nm: String, teamId tid: Int, size sz: CGSize, position pos: CGPoint, bounds bnds: CGRect, energy engy: Double){
		mNodeName	= nm
		mTeamId		= tid
		mSize		= sz
		mPosition	= pos
		mBounds		= bnds
		mEnergy		= engy
		super.init(name: "SpriteNodeStatus")

		super.setMember(name: KCSpriteNodeStatus.NameItem,     value: CNNativeValue.stringValue(nm))
		super.setMember(name: KCSpriteNodeStatus.TeamIdItem,   value: CNNativeValue.numberValue(NSNumber(integerLiteral: tid)))
		super.setMember(name: KCSpriteNodeStatus.SizeItem,     value: CNNativeValue.sizeValue(sz))
		super.setMember(name: KCSpriteNodeStatus.PositionItem, value: CNNativeValue.pointValue(pos))
		super.setMember(name: KCSpriteNodeStatus.BoundsItem,   value: CNNativeValue.rectValue(bnds))
		super.setMember(name: KCSpriteNodeStatus.EnergyItem,   value: CNNativeValue.numberValue(NSNumber(floatLiteral: Double(engy))))
	}

	public var name:     String 	{ get { return mNodeName 	}}
	public var teamId:   Int	{ get { return mTeamId 		}}
	public var size:     CGSize	{ get { return mSize 		}}
	public var position: CGPoint	{ get { return mPosition 	}}
	public var bounds:   CGRect 	{ get { return mBounds 		}}
	public var energy:   Double 	{ get { return mEnergy 		}}

	public class func spriteNodeStatus(from val: CNNativeValue) -> KCSpriteNodeStatus? {
		if let name  = val.stringProperty(identifier: KCSpriteNodeStatus.NameItem),
		   let tid   = val.numberProperty(identifier: KCSpriteNodeStatus.TeamIdItem),
		   let sz    = val.sizeProperty(identifier: KCSpriteNodeStatus.SizeItem),
		   let pos   = val.pointProperty(identifier: KCSpriteNodeStatus.PositionItem),
		   let bnds  = val.rectProperty(identifier: KCSpriteNodeStatus.BoundsItem),
		   let engy  = val.numberProperty(identifier: KCSpriteNodeStatus.EnergyItem) {
			return KCSpriteNodeStatus(name: name, teamId: tid.intValue, size: sz, position: pos, bounds: bnds, energy: engy.doubleValue)
		}
		NSLog("Failed to decode KCSpriteNodeStatus")
		return nil
	}
}



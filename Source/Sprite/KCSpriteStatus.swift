/**
 * @file KCSpriteStatus.swift
 * @brief Define KCSpriteStatus class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteStatus: CNNativeStruct
{
	public static let DEFAULT_ENERGY: Double	= 1.0

	public static let NameItem		= "name"
	public static let TeamIdItem		= "teamId"
	public static let SizeItem		= "size"
	public static let PositionItem		= "position"
	public static let BoundsItem		= "bounds"
	public static let EnergyItem		= "energy"
	public static let MissileNumItem	= "missileNum"

	private var	mNodeName:		String
	private var	mTeamId:		Int
	private var	mSize:			CGSize
	private var 	mPosition:		CGPoint
	private var	mBounds:		CGRect
	private var	mEnergy:		Double
	private var 	mMissileNum:		Int

	public init(name nm: String, teamId tid: Int, size sz: CGSize, position pos: CGPoint, bounds bnds: CGRect, energy engy: Double, missileNum mnum: Int){
		mNodeName	= nm
		mTeamId		= tid
		mSize		= sz
		mPosition	= pos
		mBounds		= bnds
		mEnergy		= engy
		mMissileNum	= mnum
		super.init(name: "SpriteStatus")

		super.setMember(name: KCSpriteStatus.NameItem,     	value: CNNativeValue.stringValue(nm))
		super.setMember(name: KCSpriteStatus.TeamIdItem,   	value: CNNativeValue.numberValue(NSNumber(integerLiteral: tid)))
		super.setMember(name: KCSpriteStatus.SizeItem,     	value: CNNativeValue.sizeValue(sz))
		super.setMember(name: KCSpriteStatus.PositionItem, 	value: CNNativeValue.pointValue(pos))
		super.setMember(name: KCSpriteStatus.BoundsItem,   	value: CNNativeValue.rectValue(bnds))
		super.setMember(name: KCSpriteStatus.EnergyItem,   	value: CNNativeValue.numberValue(NSNumber(floatLiteral: Double(engy))))
		super.setMember(name: KCSpriteStatus.MissileNumItem,	value: CNNativeValue.numberValue(NSNumber(integerLiteral: mnum)))
	}

	public var name:     	String 	{ get { return mNodeName 	}}
	public var teamId:   	Int	{ get { return mTeamId 		}}
	public var size:     	CGSize	{ get { return mSize 		}}
	public var position: 	CGPoint	{ get { return mPosition 	}}
	public var bounds:   	CGRect 	{ get { return mBounds 		}}
	public var energy:   	Double 	{ get { return mEnergy 		}}
	public var missileNum:	Int 	{ get { return mMissileNum	}}

	public class func spriteStatus(from val: CNNativeValue) -> KCSpriteStatus? {
		if let name  = val.stringProperty(identifier: KCSpriteStatus.NameItem),
		   let tid   = val.numberProperty(identifier: KCSpriteStatus.TeamIdItem),
		   let sz    = val.sizeProperty(identifier: KCSpriteStatus.SizeItem),
		   let pos   = val.pointProperty(identifier: KCSpriteStatus.PositionItem),
		   let bnds  = val.rectProperty(identifier: KCSpriteStatus.BoundsItem),
		   let engy  = val.numberProperty(identifier: KCSpriteStatus.EnergyItem),
		   let mnum  = val.numberProperty(identifier: KCSpriteStatus.MissileNumItem) {
			return KCSpriteStatus(name: name, teamId: tid.intValue, size: sz, position: pos, bounds: bnds, energy: engy.doubleValue, missileNum: mnum.intValue)
		}
		NSLog("Failed to decode KCSpriteStatus")
		return nil
	}
}



/**
 * @file KCSpriteAction.swift
 * @brief Define KCSpriteNodeAction class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public class KCSpriteNodeAction: CNNativeStruct
{
	public static let SpeedItem		= "speed"
	public static let AngleItem		= "angle"

	private var mSpeed:		CGFloat		/* [m/sec]		*/
	private var mAngle:		CGFloat		/* [radian]		*/

	public init(speed spd: CGFloat, angle ang: CGFloat) {
		mSpeed   = spd
		mAngle   = ang
		super.init(name: "SpriteNodeAction")

		/* Setup members */
		let speedobj = NSNumber(floatLiteral: Double(spd))
		let angleobj = NSNumber(floatLiteral: Double(ang))
		super.setMember(name: KCSpriteNodeAction.SpeedItem, value: CNNativeValue.numberValue(speedobj))
		super.setMember(name: KCSpriteNodeAction.AngleItem, value: CNNativeValue.numberValue(angleobj))
	}

	public var speed:  CGFloat { get { return mSpeed		}}
	public var angle:  CGFloat { get { return mAngle 		}}
	public var xSpeed: CGFloat { get { return mSpeed * sin(mAngle)	}}
	public var ySpeed: CGFloat { get { return mSpeed * cos(mAngle)	}}

	public static func spriteNodeAction(from value: CNNativeValue) -> KCSpriteNodeAction? {
		if let speed   = value.numberProperty(identifier: KCSpriteNodeAction.SpeedItem),
		   let angle   = value.numberProperty(identifier: KCSpriteNodeAction.AngleItem) {
			return KCSpriteNodeAction(speed: CGFloat(speed.doubleValue), angle: CGFloat(angle.doubleValue))
		} else {
			return nil
		}
	}
}



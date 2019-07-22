/**
 * @file KCSpriteAction.swift
 * @brief Define KCSpriteNodeAction class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import Foundation

public struct KCSpriteNodeAction {
	public var	speed:		CGFloat		/* [m/sec]		*/
	public var 	angle:		CGFloat		/* [radian]		*/

	public init(){
		self.init(speed: 0.0, angle: 0.0)
	}

	public init(speed spd: CGFloat, angle agl: CGFloat) {
		speed   = spd
		angle   = agl
	}

	public var xSpeed: CGFloat { get { return speed * sin(angle) }}
	public var ySpeed: CGFloat { get { return speed * cos(angle) }}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["speed"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(speed)))
		top["angle"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(angle)))
		return CNNativeValue.dictionaryValue(top)
	}

	public static func spriteNodeAction(from value: CNNativeValue) -> KCSpriteNodeAction? {
		if let speed   = value.numberProperty(identifier: "speed"),
			let angle   = value.numberProperty(identifier: "angle") {
			return KCSpriteNodeAction(speed: CGFloat(speed.doubleValue), angle: CGFloat(angle.doubleValue))
		} else {
			return nil
		}
	}
}

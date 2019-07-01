/**
 * @file KCSpriteNode.swift
 * @brief Define KCSpriteNode class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import SpriteKit
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

public struct KCSpriteNodeStatus
{
	public static let DEFAULT_ENERGY: Double	= 1.0

	public var	size:		CGSize
	public var 	position:	CGPoint
	public var	energy:		Double

	public init(){
		self.init(size: CGSize.zero, position: CGPoint.zero, energy: KCSpriteNodeStatus.DEFAULT_ENERGY)
	}

	public init(size sz: CGSize, position pos: CGPoint, energy engy: Double){
		size     = sz
		position = pos
		energy	 = engy
	}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["size"]     = CNNativeValue.sizeValue(size)
		top["position"] = CNNativeValue.pointValue(position)
		top["energy"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: energy))
		return CNNativeValue.dictionaryValue(top)
	}

	public static func spriteNodeStatus(from value: CNNativeValue) -> KCSpriteNodeStatus? {
		if let size = value.sizeProperty(identifier:  "size"),
		   let pos  = value.pointProperty(identifier: "position"),
		   let engy = value.numberProperty(identifier: "energy") {
			return KCSpriteNodeStatus(size: size, position: pos, energy: engy.doubleValue)
		} else {
			return nil
		}
	}
}

public class KCSpriteNode: SKSpriteNode, SKPhysicsContactDelegate
{
	private weak var mParentScene:	KCSpriteScene?
	private var	 mEnergy:	Double

	public init(parentScene scene: KCSpriteScene, image img: CNImage, initStatus istat: KCSpriteNodeStatus, initialAction iact: KCSpriteNodeAction){
		mParentScene = scene
		mEnergy	     = istat.energy
		let tex      = SKTexture(image: img)
		let physize  = scene.logicalToPhysical(size: istat.size)
		super.init(texture: tex, color: KCColor.white, size: physize)

		/* Apply status */
		self.scale(to: physize)
		self.position = scene.logicalToPhysical(point: istat.position)


		let body = SKPhysicsBody(rectangleOf: physize)
		body.setup(bodyType: .Object)
		self.physicsBody = body

		/* Set after physicsBody */
		self.action   = iact
		//NSLog("node: log=\(istat.size.description), phys=\(physize.description)")
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var status: KCSpriteNodeStatus {
		get {
			if let scene = mParentScene {
				let size     = scene.physicalToLogical(size: self.size)
				let position = scene.physicalToLogical(point: self.position)
				return KCSpriteNodeStatus(size: size, position: position, energy: mEnergy)
			} else {
				return KCSpriteNodeStatus()
			}
		}
	}
	
	public var action: KCSpriteNodeAction {
		get {
			if let body = self.physicsBody, let scene = mParentScene {
				let dx      = scene.physicalToLogical(xSpeed: body.velocity.dx)
				let dy	    = scene.physicalToLogical(ySpeed: body.velocity.dy)
				let speed   = sqrt(dx*dx + dy*dy)
				let angle   = atan2(dx, dy)
				return KCSpriteNodeAction(speed: speed, angle: angle)
			} else {
				return KCSpriteNodeAction()
			}
		}
		set(newact){
			if let body = self.physicsBody, let scene = mParentScene {
				self.isHidden = false
				let dx = scene.logicalToPhysical(xSpeed: newact.xSpeed)
				let dy = scene.logicalToPhysical(ySpeed: newact.ySpeed)
				body.velocity = CGVector(dx: dx, dy: dy)
				self.zRotation = -atan2(dx, dy)
			}
		}
	}

	public func applyDamage(damage dmg: Double){
		if mEnergy > dmg {
			mEnergy -= dmg
		} else {
			mEnergy = 0.0
		}
	}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]

		/* name */
		let name: String
		if let str = self.name { name = str } else { name = "<unknown>" }
		top["name"]   = CNNativeValue.stringValue(name)
		top["status"] = status.toValue()
		top["action"] = action.toValue()
		
		return CNNativeValue.dictionaryValue(top)
	}
}


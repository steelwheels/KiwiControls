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
	public var	active:		Bool		/* active or inactive	*/
	public var	speed:		CGFloat		/* [m/sec]		*/
	public var 	angle:		CGFloat		/* [radian]		*/

	public init(){
		self.init(active: true, speed: 0.0, angle: 0.0)
	}

	public init(active act: Bool, speed spd: CGFloat, angle agl: CGFloat) {
		active	= act
		speed   = spd
		angle   = agl
	}

	public var xSpeed: CGFloat { get { return speed * sin(angle) }}
	public var ySpeed: CGFloat { get { return speed * cos(angle) }}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["active"]  = CNNativeValue.numberValue(NSNumber(booleanLiteral: active))
		top["speed"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(speed)))
		top["angle"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(angle)))
		//top["xSpeed"]  = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(xSpeed)))
		//top["ySpeed"]  = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(ySpeed)))
		return CNNativeValue.dictionaryValue(top)
	}

	public static func spriteNodeAction(from value: CNNativeValue) -> KCSpriteNodeAction? {
		if let active  = value.numberProperty(identifier: "active"),
		   let speed   = value.numberProperty(identifier: "speed"),
		   let angle   = value.numberProperty(identifier: "angle") {
			return KCSpriteNodeAction(active: active.boolValue, speed: CGFloat(speed.doubleValue), angle: CGFloat(angle.doubleValue))
		} else {
			return nil
		}
	}
}

public struct KCSpriteNodeStatus
{
	public var	size:		CGSize
	public var 	position:	CGPoint

	public init(){
		self.init(size: CGSize.zero, position: CGPoint.zero)
	}

	public init(size sz: CGSize, position pos: CGPoint){
		size     = sz
		position = pos
	}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["size"]     = CNNativeValue.sizeValue(size)
		top["position"] = CNNativeValue.pointValue(position)
		return CNNativeValue.dictionaryValue(top)
	}

	public static func spriteNodeStatus(from value: CNNativeValue) -> KCSpriteNodeStatus? {
		if let size = value.sizeProperty(identifier:  "size"),
		   let pos  = value.pointProperty(identifier: "position") {
			return KCSpriteNodeStatus(size: size, position: pos)
		} else {
			return nil
		}
	}
}

public class KCSpriteNode: SKSpriteNode, SKPhysicsContactDelegate
{
	private weak var mParentScene:	KCSpriteScene?
	private var mStatus:		KCSpriteNodeStatus

	public init(parentScene scene: KCSpriteScene, image img: CNImage, initStatus istat: KCSpriteNodeStatus){
		mParentScene = scene
		mStatus      = istat
		let tex      = SKTexture(image: img)
		let physize  = scene.logicalToPhysical(size: istat.size)
		super.init(texture: tex, color: KCColor.white, size: physize)

		/* Apply status */
		self.scale(to: physize)
		self.position = scene.logicalToPhysical(point: istat.position)

		let body = SKPhysicsBody(rectangleOf: physize)
		body.setup(bodyType: .Object)
		self.physicsBody = body

		NSLog("node: log=\(istat.size.description), phys=\(physize.description)")
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var status: KCSpriteNodeStatus {
		get {
			if let scene = mParentScene {
				let size     = scene.physicalToLogical(size: self.size)
				let position = scene.physicalToLogical(point: self.position)
				return KCSpriteNodeStatus(size: size, position: position)
			} else {
				return KCSpriteNodeStatus()
			}
		}
	}
	
	public var action: KCSpriteNodeAction {
		get {
			if let body = self.physicsBody, let scene = mParentScene {
				let active  = true
				let dx      = scene.physicalToLogical(xSpeed: body.velocity.dx)
				let dy	    = scene.physicalToLogical(ySpeed: body.velocity.dy)
				let speed   = sqrt(dx*dx + dy*dy)
				let angle   = atan2(dx, dy)
				return KCSpriteNodeAction(active: active, speed: speed, angle: angle)
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

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]

		/* name */
		let name: String
		if let str = self.name { name = str } else { name = "<unknown>" }
		top["name"] = CNNativeValue.stringValue(name)

		/* status */
		let stats = mStatus.toValue()
		top["status"] = stats

		/* action */
		let acts = action.toValue()
		top["action"] = acts
		
		return CNNativeValue.dictionaryValue(top)
	}
}


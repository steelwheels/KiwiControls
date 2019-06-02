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
	public var	visible:	Bool
	public var	speed:		CGFloat		/* [m/sec]	*/
	public var 	angle:		CGFloat		/* [radian]	*/

	public init(){
		self.init(visible: false, speed: 0.0, angle: 0.0)
	}

	public init(visible vis: Bool, speed spd: CGFloat, angle agl: CGFloat) {
		visible	= vis
		speed   = spd
		angle   = agl
	}

	public var xSpeed: CGFloat { get { return speed * sin(angle) }}
	public var ySpeed: CGFloat { get { return speed * cos(angle) }}

	public func toValue() -> CNNativeValue {
		var top: Dictionary<String, CNNativeValue> = [:]
		top["visible"] = CNNativeValue.numberValue(NSNumber(booleanLiteral: visible))
		top["speed"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(speed)))
		top["angle"]   = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(angle)))
		//top["xSpeed"]  = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(xSpeed)))
		//top["ySpeed"]  = CNNativeValue.numberValue(NSNumber(floatLiteral: Double(ySpeed)))
		return CNNativeValue.dictionaryValue(top)
	}

	public static func spriteNodeAction(from value: CNNativeValue) -> KCSpriteNodeAction? {
		if let visible = value.numberProperty(identifier: "visible"),
		   let speed   = value.numberProperty(identifier: "speed"),
		   let angle   = value.numberProperty(identifier: "angle") {
			return KCSpriteNodeAction(visible: visible.boolValue, speed: CGFloat(speed.doubleValue), angle: CGFloat(angle.doubleValue))
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

public struct KCSpriteNodeAttribute
{
	public var attribute:	CNNativeValue

	public init(){
		attribute = .nullValue
	}
}

public class KCSpriteNode: SKSpriteNode, SKPhysicsContactDelegate
{
	private weak var mParentScene:	KCSpriteScene?
	private var mStatus:		KCSpriteNodeStatus
	private var mAttribute:		KCSpriteNodeAttribute

	public init(parentScene scene: KCSpriteScene, image img: CNImage, initStatus istat: KCSpriteNodeStatus, field fld: KCSpriteField){
		mParentScene = scene
		mStatus      = istat
		mAttribute   = KCSpriteNodeAttribute()
		let tex      = SKTexture(image: img)
		let physize  = fld.logicalToPhysical(size: istat.size)
		super.init(texture: tex, color: KCColor.white, size: physize)

		/* Apply status */
		self.scale(to: physize)
		self.position = fld.logicalToPhysical(point: istat.position)

		let body = SKPhysicsBody(rectangleOf: physize)
		body.setup(bodyType: .Object)
		self.physicsBody = body

		NSLog("node: log=\(istat.size.description), phys=\(physize.description)")
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var status: KCSpriteNodeStatus {
		get { return mStatus }
	}

	public var attribute: CNNativeValue {
		get { return mAttribute.attribute }
		set(newattr) { mAttribute.attribute = newattr }
	}

	private var field: KCSpriteField {
		get {
			if let scene = mParentScene {
				return scene.field
			} else {
				fatalError("Can not happen")
			}
		}
	}

	public var action: KCSpriteNodeAction {
		get {
			if let body = self.physicsBody {
				let fld = field

				let visible = !self.isHidden
				let dx      = fld.physicalToLogical(xSpeed: body.velocity.dx)
				let dy	    = fld.physicalToLogical(ySpeed: body.velocity.dy)
				let speed   = sqrt(dx*dx + dy*dy)
				let angle   = atan2(dx, dy)
				return KCSpriteNodeAction(visible: visible, speed: speed, angle: angle)
			} else {
				return KCSpriteNodeAction()
			}
		}
		set(newact){
			if let body = self.physicsBody {
				let fld = field
				self.isHidden = !newact.visible
				let dx = fld.logicalToPhysical(xSpeed: newact.xSpeed)
				let dy = fld.logicalToPhysical(ySpeed: newact.ySpeed)
				body.velocity = CGVector(dx: dx, dy: dy)
			}
			self.zRotation = newact.angle
		}
	}

	public func update(_ currentTime: TimeInterval) {
		if let body = self.physicsBody {
			/* Update angle */
			let dx    = body.velocity.dx
			let dy    = body.velocity.dy
			let angle = atan2(dx, dy)
			self.zRotation = -angle
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


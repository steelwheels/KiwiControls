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

public class KCSpriteNode: SKSpriteNode, SKPhysicsContactDelegate
{
	private var	mMapper:	CNGraphicsMapper
	private var	mName:		String
	private var	mTeamId:	Int
	private var	mEnergy:	Double

	public init(graphiceMapper mapper: CNGraphicsMapper, image img: CNImage, initStatus istat: KCSpriteNodeStatus, initialAction iact: KCSpriteNodeAction){
		mMapper	     = mapper
		mName        = istat.name
		mTeamId      = istat.teamId
		mEnergy	     = istat.energy
		let tex      = SKTexture(image: img)
		let psize    = mapper.logicalToPhysical(size: istat.size)
		super.init(texture: tex, color: KCColor.white, size: psize)

		/* Apply status */
		self.scale(to: psize)
		self.position = mapper.logicalToPhysical(point: istat.position)
		
		let body = SKPhysicsBody(rectangleOf: psize)
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
			let lsize  = mMapper.physicalToLogical(size:  self.size)
			let lpos   = mMapper.physicalToLogical(point: self.position)
			let bounds = CGRect(origin: CGPoint.zero, size: mMapper.logicalSize)
			return KCSpriteNodeStatus(name: mName, teamId: mTeamId, size: lsize, position: lpos, bounds: bounds, energy: mEnergy)
		}
	}
	
	public var action: KCSpriteNodeAction {
		get {
			if let body = self.physicsBody {
				let vec   = mMapper.physicalToLogical(vector: body.velocity)
				let speed = sqrt(vec.dx * vec.dx + vec.dy * vec.dy)
				let angle = atan2(vec.dx, vec.dy)
				return KCSpriteNodeAction(speed: speed, angle: angle)
			} else {
				return KCSpriteNodeAction()
			}
		}
		set(newact){
			if let body = self.physicsBody {
				self.isHidden = false
				let vec = mMapper.logicalToPhysical(vector: CGVector(dx: newact.xSpeed, dy: newact.ySpeed))
				body.velocity  = vec
				self.zRotation = -atan2(vec.dx, vec.dy) // counter clock wise
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


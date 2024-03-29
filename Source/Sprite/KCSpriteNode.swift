/**
 * @file KCSpriteNode.swift
 * @brief Define KCSpriteNode class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

public class KCSpriteNode: SKSpriteNode, SKPhysicsContactDelegate
{
	private var	mMapper:	CNGraphicsMapper
	private var	mName:		String
	private var	mTeamId:	Int
	private var	mEnergy:	Double
	private var 	mMissileNum:	Int
	private var	mCondition:	KCSpriteCondition

	public init(graphicsMapper mapper: CNGraphicsMapper, image img: CNImage, initStatus istat: KCSpriteStatus, initialAction iact: KCSpriteNodeAction, condition cond: KCSpriteCondition){
		mMapper	     = mapper
		mName        = istat.name
		mTeamId      = istat.teamId
		mEnergy	     = istat.energy
		mMissileNum  = istat.missileNum
		mCondition   = cond
		let tex      = SKTexture(image: img)
		let psize    = mapper.logicalToPhysical(size: istat.size)
		super.init(texture: tex, color: CNColor.white, size: psize)

		/* Apply status */
		self.name = istat.name
		self.scale(to: psize)
		self.position = mapper.logicalToPhysical(point: istat.position)

		let body = SKPhysicsBody(rectangleOf: psize)
		body.setup(bodyType: .Object)
		self.physicsBody = body

		/* Set after physicsBody */
		self.action   = iact
	}

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var teamId: Int { return mTeamId }

	public var physicalPosition: CGPoint { get { return self.position }}
	public var logicalPosition:  CGPoint { get { return mMapper.physicalToLogical(point: self.position) }}

	public var status: KCSpriteStatus {
		get {
			let lsize  = mMapper.physicalToLogical(size:  self.size)
			let lpos   = mMapper.physicalToLogical(point: self.position)
			let bounds = CGRect(origin: CGPoint.zero, size: mMapper.logicalSize)
			return KCSpriteStatus(name: mName, teamId: mTeamId, size: lsize, position: lpos, bounds: bounds, energy: mEnergy, missileNum: mMissileNum)
		}
	}

	public var condition: KCSpriteCondition {
		get { return mCondition }
	}

	public var action: KCSpriteNodeAction {
		get {
			if let body = self.physicsBody {
				let vec   = mMapper.physicalToLogical(vector: body.velocity)
				let speed = sqrt(vec.dx * vec.dx + vec.dy * vec.dy)
				let angle = atan2(vec.dx, vec.dy)
				return KCSpriteNodeAction(speed: speed, angle: angle)
			} else {
				return KCSpriteNodeAction(speed: 0.0, angle: 0.0)
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

	public func applyDamage(by condition: KCSpriteCondition){
		let damage = self.mCondition.receivingCollisionDamage + condition.givingCollisionDamage
		if mEnergy > damage {
			mEnergy -= damage
		} else {
			mEnergy = 0.0
		}
	}

	public static func isSame(nodeA na: KCSpriteNode, nodeB nb: KCSpriteNode) -> Bool {
		if na.mTeamId == nb.mTeamId && na.mName == nb.mName {
			return true
		} else {
			return false
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


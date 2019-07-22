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
	private var	mCondition:	KCSpriteNodeCondition

	public init(graphiceMapper mapper: CNGraphicsMapper, image img: CNImage, initStatus istat: KCSpriteNodeStatus, initialAction iact: KCSpriteNodeAction, condition cond: KCSpriteNodeCondition){
		mMapper	     = mapper
		mName        = istat.name
		mTeamId      = istat.teamId
		mEnergy	     = istat.energy
		mCondition   = cond
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

	public var condition: KCSpriteNodeCondition {
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

	public func applyDamage(by condition: KCSpriteNodeCondition){
		let damage = self.mCondition.receivingCollisionDamage + condition.givingCollisionDamage
		if mEnergy > damage {
			mEnergy -= damage
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


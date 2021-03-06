/**
 * @file KCSpriteScene.swift
 * @brief Define KCSpriteScene class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

public class KCSpriteScene: SKScene, SKPhysicsContactDelegate
{
	public typealias ContactObserverHandler     	= (_ point: KCPoint, _ status: KCSpriteStatus) -> Void
	public typealias ContinuationCheckerHandler	= (_ status: Array<KCSpriteStatus>) -> Bool

	private struct NodeInfo {
		public var 	node:		KCSpriteNode
		public var 	context:	CNOperationContext?

		public init(node nd: KCSpriteNode, context ctxt: CNOperationContext?){
			node	= nd
			context	= ctxt
		}
	}

	private var mQueue:		CNOperationQueue
	private var mNodes:		Dictionary<String, NodeInfo>		// node-name, node-info
	private var mMapper:		CNGraphicsMapper
	private var mDamageByWall:	Double

	public var contactObserverHandler:	ContactObserverHandler?
	public var continuationCheckerHandler:	ContinuationCheckerHandler?

	public init(frame frm: CGRect){
		mQueue			= CNOperationQueue()
		mNodes   		= [:]
		mMapper			= CNGraphicsMapper(physicalSize: frm.size)
		mDamageByWall		= 0.0
		contactObserverHandler	= nil
		super.init(size: frm.size)

		/* Setup scene */
		self.name = "_scene"

		/* Allocate boundary */
		resize(sceneSize: frm.size)

		/* Allocate world */
		physicsWorld.setup(delegate: self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var logicalSize: CGSize {
		get {
			return mMapper.logicalSize
		}
		set(newsize){
			mMapper.logicalSize = newsize
		}
	}

	public func setLogicalSizeWithKeepingAspectRatio(width val: CGFloat) -> CGSize {
		let psize = mMapper.physicalSize
		guard psize.width > 0.0 && psize.height > 0.0 else {
			NSLog("Invalid physical size")
			return CGSize.zero
		}
		let hval  = val * psize.height / psize.width
		let lsize = CGSize(width: val, height: hval)
		logicalSize = lsize
		return lsize
	}

	private var mPrevBodySize: KCSize = KCSize.zero
	public func resize(sceneSize size: KCSize) {
		self.size = size
		mMapper.physicalSize = size

		if mPrevBodySize != size {
			let frame = KCRect(origin: CGPoint.zero, size: size)
			let body  = SKPhysicsBody(edgeLoopFrom: frame)
			body.setup(bodyType: .Boundary)
			physicsBody = body

			mPrevBodySize = size
		}
	}

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteStatus, initAction iact: KCSpriteNodeAction, condition cond: KCSpriteCondition, context ctxt: CNOperationContext?) -> KCSpriteNode {
		if let nodeinfo = mNodes[name] {
			return nodeinfo.node
		} else {
			/* Setup node */
			let newnode  = KCSpriteNode(graphicsMapper: mMapper, image: img, initStatus: istat, initialAction: iact, condition: cond)
			newnode.name    = name
			mNodes[name]    = NodeInfo(node: newnode, context: ctxt)
			/* Setup context */
			if let ctxt = ctxt {
				KCSpriteOperationContext.setName(context: ctxt, name: name)
				KCSpriteOperationContext.setInterval(context: ctxt, interval: 0.0)
				KCSpriteOperationContext.setStatus(context: ctxt, status: istat)
				KCSpriteOperationContext.setAction(context: ctxt, action: KCSpriteNodeAction(speed: 0.0, angle: 0.0))
			}
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.addChild(newnode)
				}
			})
			return newnode
		}
	}

	public func remove(nodeName name: String){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				myself.syncRemove(nodeName: name)
			}
		})
	}

	private func syncRemove(nodeName name: String){
		if let nodeinfo = mNodes[name] {
			self.removeChildren(in: [nodeinfo.node])
			mNodes.removeValue(forKey: name)
		}
	}

	private var mPreviousTime: TimeInterval? = nil

	public var damageByWall: Double {
		get { return mDamageByWall }
		set(newval) { mDamageByWall = newval }
	}

	open override func update(_ currentTime: TimeInterval) {
		/* Ignore first call to get previous system time */
		guard let prevtime = mPreviousTime else {
			mPreviousTime = currentTime
			return
		}

		/* Get interval */
		let interval  = max(0.0, currentTime - prevtime)
		mPreviousTime = currentTime

		/* Decide continue or not */
		if let checker = continuationCheckerHandler {
			var status: Array<KCSpriteStatus> = []
			for nodeinfo in mNodes.values {
				status.append(nodeinfo.node.status)
			}
			if !checker(status) {
				self.isPaused = true
				return
			}
		}

		/* Set inputs for each node */
		for name in mNodes.keys {
			if let nodeinfo = mNodes[name] {
				let node  = nodeinfo.node
				let radar = generateRadarInfo(for: node)
				if let ctxt = nodeinfo.context {
					KCSpriteOperationContext.setName(context: ctxt, name: name)
					KCSpriteOperationContext.setInterval(context: ctxt, interval: interval)
					KCSpriteOperationContext.setAction(context: ctxt, action: node.action)
					KCSpriteOperationContext.setRadar(context: ctxt, radar: radar)
					KCSpriteOperationContext.setStatus(context: ctxt, status: node.status)
				}
			} else {
				CNLog(logLevel: .error, message: "Invalid properties")
			}
		}

		/* Collect contexts */
		var contexts: Array<CNOperationContext> = []
		for nodeinfo in mNodes.values {
			if let ctxt = nodeinfo.context{
				contexts.append(ctxt)
			}
		}
		if contexts.count > 0 {
			/* Execute operations */
			let nonexecs = mQueue.execute(operations: contexts, timeLimit: nil)
			if nonexecs.count > 0 {
				CNLog(logLevel: .error, message: "Failed to execute some operations")
			}
			/* Wailt all operations are finished */
			mQueue.waitOperations()
			/* Get results */
			for ctxt in contexts {
				if ctxt.isFinished {
					if let name   = KCSpriteOperationContext.getName(context: ctxt),
					   let status = KCSpriteOperationContext.getStatus(context: ctxt),
					   let result = KCSpriteOperationContext.getResult(context: ctxt) {
						if status.energy > 0.0 {
							if let nodeinfo = mNodes[name] {
								nodeinfo.node.action = result
								CNLog(logLevel: .debug, message: "action=\(result.angle)")
							}
						} else {
							syncRemove(nodeName: name)
						}
					} else {
						CNLog(logLevel: .error, message: "The operation has no result")
					}
				} else {
					reportFailure(context: ctxt)
				}
			}
		}
	}

	private func reportFailure(context ctxt: CNOperationContext){
		if let name = KCSpriteOperationContext.getName(context: ctxt) {
			ctxt.console.error(string: "Failed to execute \(name)\n")
			syncRemove(nodeName: name)
			return // without errors
		}
		CNLog(logLevel: .error, message: "Internal error")
	}

	private func generateRadarInfo(for node: KCSpriteNode) -> KCSpriteRadar {
		let rrange = CGFloat(node.condition.radarRange)
		let result = KCSpriteRadar()
		if rrange <= 0.0 {
			return result
		}
		let lpos = node.logicalPosition
		var positions: Array<KCSpriteRadar.NodePosition> = []
		for oinfo in mNodes.values {
			let other = oinfo.node
			let opos  = other.logicalPosition
			if !KCSpriteNode.isSame(nodeA: other, nodeB: node) {
				if CNGraphics.distance(pointA: opos, pointB: lpos) <= rrange {
					if let oname = other.name {
						let pos = KCSpriteRadar.NodePosition(name: oname, teamId: other.teamId, position: opos)
						positions.append(pos)
					} else {
						NSLog("KCSpriteScene.generateRadarInfo: No node name")
					}
				}
			}
		}
		result.setPositions(positions: positions)
		return result
	}


	/* Begin contact */
	public func didBegin(_ contact: SKPhysicsContact) {
		/* Do nothing */
	}

	/* End contact */
	public func didEnd(_ contact: SKPhysicsContact) {
		doContactEvent(contact: contact)
	}

	private func doContactEvent(contact cont: SKPhysicsContact){
		let pt    = cont.contactPoint
		let nodeA = cont.bodyA.node as? KCSpriteNode
		let nodeB = cont.bodyB.node as? KCSpriteNode

		let condA: KCSpriteCondition
		if let node = nodeA {
			condA = node.condition
		} else {
			condA = KCSpriteCondition(givingCollisionDamage: mDamageByWall, receivingCollisionDamage: 0.0, radarRange: 0.0)
		}

		let condB: KCSpriteCondition
		if let node = nodeB {
			condB = node.condition
		} else {
			condB = KCSpriteCondition(givingCollisionDamage: mDamageByWall, receivingCollisionDamage: 0.0, radarRange: 0.0)
		}

		if let node = nodeA {
			node.applyDamage(by: condB)
			/* Call handler */
			if let handler = contactObserverHandler {
				handler(pt, node.status)
			}
		}
		if let node = nodeB {
			node.applyDamage(by: condA)
			/* Call handler */
			if let handler = contactObserverHandler {
				handler(pt, node.status)
			}
		}
	}

	private func nodeToOperation(node nd: KCSpriteNode?) -> CNOperationContext? {
		if let node = nd {
			if let name = node.name {
				if let nodeinfo = mNodes[name] {
					return nodeinfo.context
				}
			}
		}
		CNLog(logLevel: .error, message: "Operation is not found")
		return nil
	}

	private func operationToNode(context ctxt: CNOperationContext) -> KCSpriteNode? {
		if let name = KCSpriteOperationContext.getName(context: ctxt) {
			if let nodeinfo = mNodes[name] {
				return nodeinfo.node
			}
		}
		CNLog(logLevel: .error, message: "Node is not found")
		return nil
	}
}



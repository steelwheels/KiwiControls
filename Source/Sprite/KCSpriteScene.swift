/**
 * @file KCSpriteScene.swift
 * @brief Define KCSpriteScene class
 * @par Copyright
 *   Copyright (C) 2019 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

public class KCSpriteScene: SKScene, SKPhysicsContactDelegate, CNLogging
{
	public typealias ContactObserverHandler     	= (_ point: KCPoint, _ status: KCSpriteNodeStatus) -> Void
	public typealias ContinuationCheckerHandler	= (_ status: Array<KCSpriteNodeStatus>) -> Bool

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
	private var mConsole:		CNConsole?
	private var mMapper:		CNGraphicsMapper
	private var mWallCondition:	KCSpriteNodeCondition

	public var console: 		CNConsole? { get { return mConsole }}

	public var contactObserverHandler:	ContactObserverHandler?
	public var continuationCheckerHandler:	ContinuationCheckerHandler?

	public init(frame frm: CGRect, console cons: CNConsole?){
		mQueue			= CNOperationQueue()
		mNodes   		= [:]
		mConsole 		= cons
		mMapper			= CNGraphicsMapper(physicalSize: frm.size)
		mWallCondition		= KCSpriteNodeCondition(givingCollisionDamage: 0.0, receivingCollisionDamage: 0.0)
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

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteNodeStatus, initAction iact: KCSpriteNodeAction, condition cond: KCSpriteNodeCondition, context ctxt: CNOperationContext?) -> KCSpriteNode {
		if let nodeinfo = mNodes[name] {
			return nodeinfo.node
		} else {
			/* Setup node */
			let newnode  = KCSpriteNode(graphiceMapper: mMapper, image: img, initStatus: istat, initialAction: iact, condition: cond)
			newnode.name    = name
			mNodes[name]    = NodeInfo(node: newnode, context: ctxt)
			/* Setup context */
			if let ctxt = ctxt {
				KCSpriteOperationContext.setName(context: ctxt, name: name)
				KCSpriteOperationContext.setInterval(context: ctxt, interval: 0.0)
				KCSpriteOperationContext.setStatus(context: ctxt, status: istat)
				KCSpriteOperationContext.setAction(context: ctxt, action: KCSpriteNodeAction())
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

	public var wallCondition: KCSpriteNodeCondition {
		get { return mWallCondition }
		set(newcond) { mWallCondition = newcond }
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
			var status: Array<KCSpriteNodeStatus> = []
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
				let node = nodeinfo.node
				if let ctxt = nodeinfo.context {
					KCSpriteOperationContext.setName(context: ctxt, name: name)
					KCSpriteOperationContext.setInterval(context: ctxt, interval: interval)
					KCSpriteOperationContext.setAction(context: ctxt, action: node.action)
					KCSpriteOperationContext.setStatus(context: ctxt, status: node.status)
				}
			} else {
				log(type: .Error, string: "Invalid properties", file: #file, line: #line, function: #function)
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
				if let cons = console {
					cons.error(string: "Failed to execute some operations\n")
				}
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
								log(type: .Flow, string: "action=\(result.angle)", file: #file, line: #line, function: #function)
							}
						} else {
							syncRemove(nodeName: name)
						}
					} else {
						log(type: .Error, string: "The operation has no result", file: #file, line: #line, function: #function)
					}
				} else {
					reportFailure(context: ctxt)
				}
			}
		}
	}

	private func reportFailure(context ctxt: CNOperationContext){
		if let name = KCSpriteOperationContext.getName(context: ctxt), let cons = ctxt.console {
			cons.print(string: "Failed to execute \(name)\n")
			syncRemove(nodeName: name)
			return // without errors
		}
		log(type: .Error, string: "Internal error", file: #file, line: #line, function: #function)
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

		let condA: KCSpriteNodeCondition
		if let node = nodeA {
			condA = node.condition
		} else {
			condA = wallCondition
		}

		let condB: KCSpriteNodeCondition
		if let node = nodeB {
			condB = node.condition
		} else {
			condB = wallCondition
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
		log(type: .Error, string: "Operation is not found", file: #file, line: #line, function: #function)
		return nil
	}

	private func operationToNode(context ctxt: CNOperationContext) -> KCSpriteNode? {
		if let name = KCSpriteOperationContext.getName(context: ctxt) {
			if let nodeinfo = mNodes[name] {
				return nodeinfo.node
			}
		}
		log(type: .Error, string: "Node is not found", file: #file, line: #line, function: #function)
		return nil
	}
}



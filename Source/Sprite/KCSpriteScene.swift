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

	private var mQueue:		CNOperationQueue
	private var mNodes:		Dictionary<String, KCSpriteNode>	// node-name, node
	private var mContexts:		Dictionary<String, CNOperationContext>	// node-name, context
	private var mConsole:		CNConsole?
	private var mMapper:		CNGraphicsMapper

	public var console: 		CNConsole? { get { return mConsole }}

	public var conditions:			KCSpriteCondition
	public var contactObserverHandler:	ContactObserverHandler?
	public var continuationCheckerHandler:	ContinuationCheckerHandler?

	public init(frame frm: CGRect, console cons: CNConsole?){
		mQueue			= CNOperationQueue()
		mNodes   		= [:]
		mContexts		= [:]
		mConsole 		= cons
		mMapper			= CNGraphicsMapper(physicalSize: frm.size)
		conditions		= KCSpriteCondition()
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

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteNodeStatus, initAction iact: KCSpriteNodeAction, context ctxt: CNOperationContext) -> KCSpriteNode {
		if let curnode = mNodes[name] {
			return curnode
		} else {
			/* Setup node */
			let newnode  = KCSpriteNode(graphiceMapper: mMapper, image: img, initStatus: istat, initialAction: iact)
			newnode.name    = name
			mNodes[name]    = newnode
			/* Setup context */
			KCSpriteOperationContext.setName(context: ctxt, name: name)
			KCSpriteOperationContext.setInterval(context: ctxt, interval: 0.0)
			KCSpriteOperationContext.setStatus(context: ctxt, status: istat)
			KCSpriteOperationContext.setAction(context: ctxt, action: KCSpriteNodeAction())
			mContexts[name] = ctxt
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
		if let curnode = mNodes[name] {
			self.removeChildren(in: [curnode])
			mNodes.removeValue(forKey: name)
			mContexts.removeValue(forKey: name)
		}
	}

	private var mPreviousTime: TimeInterval? = nil

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
			for node in mNodes.values {
				status.append(node.status)
			}
			if !checker(status) {
				self.isPaused = true
				return
			}
		}

		/* Set inputs for each node */
		for name in mNodes.keys {
			if let action = mNodes[name]?.action, let status = mNodes[name]?.status, let op = mContexts[name] {
				KCSpriteOperationContext.setName(context: op, name: name)
				KCSpriteOperationContext.setInterval(context: op, interval: interval)
				KCSpriteOperationContext.setAction(context: op, action: action)
				KCSpriteOperationContext.setStatus(context: op, status: status)
			} else {
				log(type: .Error, string: "Invalid properties", file: #file, line: #line, function: #function)
			}
		}

		/* Execute the operation */
		let nonexecs = mQueue.execute(operations: Array(mContexts.values), timeLimit: nil)
		if nonexecs.count > 0 {
			if let cons = console {
				cons.error(string: "Failed to execute some operations\n")
			}
		}

		/* Wailt all operations are finished */
		mQueue.waitOperations()

		/* Get results */
		for (_, ctxt) in mContexts {
			if ctxt.isFinished {
				if let name   = KCSpriteOperationContext.getName(context: ctxt),
				   let status = KCSpriteOperationContext.getStatus(context: ctxt),
				   let result = KCSpriteOperationContext.getResult(context: ctxt) {
					if status.energy > 0.0 {
						if let node = mNodes[name] {
							node.action = result
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
		if let nodeA = cont.bodyA.node as? KCSpriteNode {
			applyContactEffect(node: nodeA)
			if let handler = contactObserverHandler {
				handler(pt, nodeA.status)
			}
		}
		if let nodeB = cont.bodyB.node as? KCSpriteNode {
			applyContactEffect(node: nodeB)
			if let handler = contactObserverHandler {
				handler(pt, nodeB.status)
			}
		}
	}

	private func applyContactEffect(node nd: KCSpriteNode){
		let damage = conditions.collisionDamage
		nd.applyDamage(damage: damage)
	}

	private func nodeToOperation(node nd: KCSpriteNode?) -> CNOperationContext? {
		if let node = nd {
			if let name = node.name {
				if let ctxt = mContexts[name] {
					return ctxt
				}
			}
		}
		log(type: .Error, string: "Operation is not found", file: #file, line: #line, function: #function)
		return nil
	}

	private func operationToNode(context ctxt: CNOperationContext) -> KCSpriteNode? {
		if let name = KCSpriteOperationContext.getName(context: ctxt) {
			if let node = mNodes[name] {
				return node
			}
		}
		log(type: .Error, string: "Node is not found", file: #file, line: #line, function: #function)
		return nil
	}
}



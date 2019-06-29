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
	public typealias ContactHandler     = (_ point: KCPoint, _ operation: CNOperationContext, _ targetName: String?) -> Void
	public typealias BecomeEmptyHandler = () -> Void

	private var mQueue:		CNOperationQueue
	private var mNodes:		Dictionary<String, KCSpriteNode>	// node-name, node
	private var mContexts:		Dictionary<String, CNOperationContext>	// node-name, context
	private var mConsole:		CNConsole?

	public var console: 		CNConsole? { get { return mConsole }}

	public var conditions:		KCSpriteCondition
	public var didContactHandler:	ContactHandler?
	public var becomeEmptyHandler:	BecomeEmptyHandler?

	public init(frame frm: CGRect, console cons: CNConsole?){
		mQueue			= CNOperationQueue()
		mNodes   		= [:]
		mContexts		= [:]
		mConsole 		= cons
		conditions		= KCSpriteCondition()
		didContactHandler	= nil
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

	public func logicalSize() -> CGSize {
		let psize = self.frame.size
		let lsize: CGSize
		if psize.width >= psize.height && psize.height > 0 {
			lsize = CGSize(width: psize.width / psize.height, height: 1.0)
		} else if psize.height > psize.width && psize.width > 0 {
			lsize = CGSize(width: 1.0, height: psize.height / psize.width)
		} else {
			lsize = CGSize(width: 1.0, height: 1.0)
		}
		return lsize
	}

	private var mPrevBodySize: KCSize = KCSize.zero
	public func resize(sceneSize size: KCSize) {
		self.size = size

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
			let newnode  = KCSpriteNode(parentScene: self, image: img, initStatus: istat, initialAction: iact)
			newnode.name    = name
			mNodes[name]    = newnode
			/* Setup context */
			KCSpriteOperationContext.setName(context: ctxt, name: name)
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

	open override func update(_ currentTime: TimeInterval) {
		/* If no node is exist, pause the operation */
		if mNodes.count == 0 {
			if let emphdl = self.becomeEmptyHandler {
				emphdl()
				return
			}
		}
		/* Set inputs for each node */
		for name in mNodes.keys {
			if let action = mNodes[name]?.action, let status = mNodes[name]?.status, let op = mContexts[name] {
				KCSpriteOperationContext.setName(context: op, name: name)
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
		let pt   = cont.contactPoint
		let opAp = nodeToOperation(node: cont.bodyA.node as? KCSpriteNode)
		let opBp = nodeToOperation(node: cont.bodyB.node as? KCSpriteNode)
		if let opA = opAp, let opB = opBp {
			applyContactEffect(operation: opA)
			applyContactEffect(operation: opB)
			if let handler = didContactHandler {
				handler(pt, opA, KCSpriteOperationContext.getName(context: opB))
				handler(pt, opB, KCSpriteOperationContext.getName(context: opA))
			}
		} else if let opA = opAp {
			applyContactEffect(operation: opA)
			if let handler = didContactHandler {
				handler(pt, opA, nil)
			}
		} else if let opB = opBp {
			applyContactEffect(operation: opB)
			if let handler = didContactHandler {
				handler(pt, opB, nil)
			}
		}
	}

	private func applyContactEffect(operation op: CNOperationContext){
		if var status = KCSpriteOperationContext.getStatus(context: op) {
			let damage = conditions.collisionDamage
			status.energy = max(status.energy - damage, 0.0)
			KCSpriteOperationContext.setStatus(context: op, status: status)
		}
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

	public func logicalToPhysical(size sz: CGSize) -> CGSize {
		let pframe = self.frame
		let lsize  = logicalSize()
		let width  = sz.width  * pframe.width  / lsize.width
		let height = sz.height * pframe.height / lsize.height
		return CGSize(width: width, height: height)
	}

	public func logicalToPhysical(point pt: CGPoint) -> CGPoint {
		let pframe = self.frame
		let lsize  = logicalSize()
		let x = pt.x * pframe.width  / lsize.width
		let y = pt.y * pframe.height / lsize.height
		return CGPoint(x: x, y: y)
	}

	public func logicalToPhysical(xSpeed spd: CGFloat) -> CGFloat {
		let pframe = self.frame
		let lsize  = logicalSize()
		let newspd = spd * pframe.width / lsize.width
		return newspd
	}

	public func logicalToPhysical(ySpeed spd: CGFloat) -> CGFloat {
		let pframe = self.frame
		let lsize  = logicalSize()
		let newspd = spd * pframe.height / lsize.height
		return newspd
	}

	public func physicalToLogical(size sz: CGSize) -> CGSize {
		let pframe = self.frame
		let lsize  = logicalSize()
		let width  = sz.width  * lsize.width  / pframe.width
		let height = sz.height * lsize.height / pframe.height
		return CGSize(width: width, height: height)
	}

	public func physicalToLogical(point pt: CGPoint) -> CGPoint {
		let pframe = self.frame
		let lsize  = logicalSize()
		let x = pt.x * lsize.width  / pframe.width
		let y = pt.y * lsize.height / pframe.height
		return CGPoint(x: x, y: y)
	}

	public func physicalToLogical(xSpeed speed: CGFloat) -> CGFloat {
		let pframe   = self.frame
		let lsize    = logicalSize()
		return speed * lsize.width / pframe.width
	}

	public func physicalToLogical(ySpeed speed: CGFloat) -> CGFloat {
		let pframe   = self.frame
		let lsize    = logicalSize()
		return speed * lsize.height / pframe.height
	}
}



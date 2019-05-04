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
	public typealias UpdateHandler  = (_ node: KCSpriteNode) -> KCSpriteNodeAction?
	public typealias ContactHandler = (_ point: CGPoint, _ nodeA: KCSpriteNode?, _ nodeB: KCSpriteNode?) -> Void

	private var mNodes:		Dictionary<String, KCSpriteNode>	// node-name, node
	private var mField:		KCSpriteField
	private var mConsole:		CNConsole?

	public var console: 		CNConsole? { get { return mConsole }}
	public var updateHandler:	UpdateHandler?
	public var contactBeginHandler:	ContactHandler?
	public var contactEndHandler:	ContactHandler?

	public init(frame frm: CGRect, console cons: CNConsole?){
		mNodes   		= [:]
		mField   		= KCSpriteField()
		mConsole 		= cons
		updateHandler		= nil
		contactBeginHandler	= nil
		contactEndHandler	= nil
		super.init(size: frm.size)

		/* Setup scene */
		self.name = "_scene"

		/* Setup field */
		mField.parentScene = self

		/* Allocate boundary */
		resize(sceneSize: frm.size)

		/* Allocate world */
		physicsWorld.setup(delegate: self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public var field: KCSpriteField {
		get { return mField }
	}

	private var mPrevBodySize: KCSize = KCSize.zero

	public func resize(sceneSize size: KCSize) {
		self.size  = size

		if mPrevBodySize != size {
			let frm  = KCRect(origin: CGPoint.zero, size: size)
			let body = SKPhysicsBody(edgeLoopFrom: frm)
			body.setup(bodyType: .Boundary)
			physicsBody = body

			mPrevBodySize = size
		}
	}

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteNodeStatus) -> KCSpriteNode {
		if let curnode = mNodes[name] {
			return curnode
		} else {
			let newnode  = KCSpriteNode(parentScene: self, image: img, initStatus: istat, field: mField, console: console)
			newnode.name = name
			mNodes[name] = newnode
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
		if let curnode = mNodes[name] {
			mNodes.removeValue(forKey: name)
			CNExecuteInMainThread(doSync: false, execute: {
				[weak self] () -> Void in
				if let myself = self {
					myself.removeChildren(in: [curnode])
				}
			})
		}
	}

	/* Periodically update */
	open override func update(_ currentTime: TimeInterval) {
		if let handler = updateHandler {
			for (_, node) in mNodes {
				if let newact = handler(node) {
					/* Update action */
					node.action = newact
				}
			}
		}
		/* Update node states */
		for (_, node) in mNodes {
			node.update(currentTime)
		}
	}

	/* Begin contact */
	public func didBegin(_ contact: SKPhysicsContact) {
		if let handler = contactBeginHandler {
			execContactHandler(handler: handler, contact: contact)
		}
	}

	/* End contact */
	public func didEnd(_ contact: SKPhysicsContact) {
		if let handler = contactEndHandler {
			execContactHandler(handler: handler, contact: contact)
		}
	}

	private func execContactHandler(handler hdl: ContactHandler, contact cont: SKPhysicsContact) {
		let pt = cont.contactPoint
		let nodeA = cont.bodyA.node as? KCSpriteNode
		let nodeB = cont.bodyB.node as? KCSpriteNode
		return hdl(pt, nodeA, nodeB)
	}
}



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
	public typealias UpdateHandler  = (_ currentTime: TimeInterval, _ nodes: Dictionary<String, KCSpriteNode>) -> Void
	public typealias ContactHandler = (_ point: CGPoint, _ nodeA: KCSpriteNode?, _ nodeB: KCSpriteNode?) -> Void

	private var mNodes:		Dictionary<String, KCSpriteNode>	// node-name, node
	private var mConsole:		CNConsole?

	public var console: 		CNConsole? { get { return mConsole }}
	public var updateHandler:	UpdateHandler?
	public var contactBeginHandler:	ContactHandler?
	public var contactEndHandler:	ContactHandler?

	public init(frame frm: CGRect, console cons: CNConsole?){
		mNodes   		= [:]
		mConsole 		= cons
		updateHandler		= nil
		contactBeginHandler	= nil
		contactEndHandler	= nil
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

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteNodeStatus) -> KCSpriteNode {
		if let curnode = mNodes[name] {
			return curnode
		} else {
			let newnode  = KCSpriteNode(parentScene: self, image: img, initStatus: istat)
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
		/* Update by user defined method */
		if let handler = updateHandler {
			handler(currentTime, mNodes)
		}
		/* call built-in update method */
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



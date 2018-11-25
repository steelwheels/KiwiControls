/**
 * @file KCSpriteViewCore.swift
 * @brief Define KCSpriteViewCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import SpriteKit
import Foundation

public struct KCNodeStatus {
	var isVisible:		Bool?
	var position:		KCPoint?
	var scale:		CGFloat?
	var rotation:		CGFloat?

	public init(isVisible vis: Bool?, position pos: KCPoint?, scale scl: CGFloat?, rotation rot: CGFloat?) {
		self.isVisible	= vis
		self.position	= pos
		self.scale	= scl
		self.rotation	= rot
	}
}

open class KCSpriteViewCore: KCView
{
	#if os(OSX)
	@IBOutlet weak var mSpriteView: SKView!
	#else
	@IBOutlet weak var mSpriteView: SKView!
	#endif

	private var mScene :	SKScene? = nil
	private var mNodes:	Dictionary<String, SKNode> = [:]

	public func setup(frame frm: CGRect) {
		let scene = SKScene(size: frm.size)
		scene.scaleMode = .resizeFill

		mScene = scene
		mSpriteView.presentScene(mScene)
	}

	private var scene: SKScene {
		get {
			if let scene = mScene {
				return scene
			} else {
				fatalError("No object: \(#function)")
			}
		}
	}

	public var backgroundColorOfScene: KCColor {
		get 		{ return scene.backgroundColor }
		set(color) 	{ scene.backgroundColor = color }
	}

	public func addNode(name nm: String, imageNamed iname: String, status stat: KCNodeStatus) {
		let node = SKSpriteNode(imageNamed: iname)
		node.name = nm
		mNodes[nm] = node

		if let vis = stat.isVisible {
			node.alpha = vis ? 1.0 : 0.0
		}
		if let pos = stat.position {
			node.position = pos
		}
		if let scale = stat.scale {
			node.xScale = scale ; node.yScale = scale
		}
		if let rotation = stat.rotation {
			node.zRotation = rotation
		}

		scene.addChild(node)
	}

	public func set(nodeName name: String, status stat: KCNodeStatus, durationTime dtime: TimeInterval) {
		if let node = mNodes[name] {
			var actions: Array<SKAction> = []
			if let pos = stat.position {
				if node.position != pos {
					let act = SKAction.move(to: pos, duration: dtime)
					actions.append(act)
				}
			}
			if let scale = stat.scale {
				if node.xScale != scale {
					let act = SKAction.scale(to: scale, duration: dtime)
					actions.append(act)
				}
			}
			if let rotation = stat.rotation {
				if node.zRotation != rotation {
					let act = SKAction.rotate(toAngle: rotation, duration: dtime)
					actions.append(act)
				}
			}
			if let vis = stat.isVisible {
				var act: SKAction? = nil
				if node.alpha > 0.5 {
					/* visible */
					if !vis {
						act = SKAction.fadeOut(withDuration: dtime)
					}
				} else {
					/* invisible */
					if vis {
						act = SKAction.fadeIn(withDuration: dtime)
					}
				}
				if let act = act {
					actions.append(act)
				}
			}
			if actions.count > 0 {
				node.run(SKAction.group(actions))
			}
		}
	}
}


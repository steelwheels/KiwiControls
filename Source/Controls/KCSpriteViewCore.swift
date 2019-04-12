/**
 * @file KCSpriteViewCore.swift
 * @brief Define KCSpriteViewCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

public struct KCSpriteNode
{
	private static let	ImageItem		= "image"
	private static let	ScaleItem		= "scale"
	private static let	AlphaItem		= "alpha"
	private static let	PositionItem		= "position"
	private static let	RotationItem		= "rotation"
	private static let	DurationItem		= "duration"

	public var image:		CNImage
	public var scale:		Double
	public var alpha:		Double
	public var position:		KCPoint
	public var rotation:		Double
	public var duration:		Double

	public init(image img: CNImage, scale scl: Double, alpha alp: Double, position pos: KCPoint, rotation rot: Double, duration dur: Double){
		image		= img
		scale		= scl
		alpha		= alp
		position	= pos
		rotation	= rot
		duration	= dur
	}

	public static func valueToNode(value val: CNNativeValue) -> KCSpriteNode? {
		if let record = val.toDictionary() {
			if let imgval = record[ImageItem], let sclval = record[ScaleItem],
			   let alpval = record[AlphaItem], let posval = record[PositionItem],
			   let rotval = record[RotationItem],  let durval = record[DurationItem] {
				if let img = imageInValue(value: imgval), let sclnum = sclval.toNumber(),
				   let alpnum = alpval.toNumber(), let pospt = posval.toPoint(),
		 		   let rotnum = rotval.toNumber(), let durnum = durval.toNumber() {
					return KCSpriteNode(image: img, scale: sclnum.doubleValue,
							    alpha: alpnum.doubleValue, position: pospt,
							    rotation: rotnum.doubleValue, duration: durnum.doubleValue)
				}
			}
		}
		return nil
	}

	private static func imageInValue(value val: CNNativeValue) -> CNImage? {
		if let image = val.toImage() {
			return image
		} else {
			CNLog(type: .Error, message: "No image", file: #file, line: #line, function: #function)
			return nil
		}
	}

	public func toValue() -> CNNativeValue {
		let scanum = NSNumber(value: scale)
		let alnum  = NSNumber(value: alpha)
		let rotnum = NSNumber(value: rotation)
		let durnum = NSNumber(value: duration)
		let params: Dictionary<String, CNNativeValue> = [
			KCSpriteNode.ImageItem:		.imageValue(image),
			KCSpriteNode.ScaleItem:		.numberValue(scanum),
			KCSpriteNode.AlphaItem:		.numberValue(alnum),
			KCSpriteNode.PositionItem:	.pointValue(position),
			KCSpriteNode.RotationItem:	.numberValue(rotnum),
			KCSpriteNode.DurationItem:	.numberValue(durnum)
		]
		return .dictionaryValue(params)
	}
}

public class KCSpriteViewDatabase: CNMainDatabase
{
	private var mScene:		SKScene?
	private var mNodes:		Dictionary<String, SKNode>

	public override init() {
		//mScene	 = nil
		mNodes   = [:]
	}

	public var scene: SKScene {
		get {
			if let scn = mScene {
				return scn
			} else {
				fatalError("No scene")
			}
		}
		set(newscene){
			mScene = newscene
		}
	}

	open override func updateUncached(cache cdata: Dictionary<String, CNNativeValue>, deletedItems deleted: Set<String>){
		CNExecuteInMainThread(doSync: false, execute: {
			[weak self] () -> Void in
			if let myself = self {
				myself.updateUncachedInSync(cache: cdata, deletedItems: deleted)
			}
		})
	}

	private func updateUncachedInSync(cache cdata: Dictionary<String, CNNativeValue>, deletedItems deleted: Set<String>){
		/* Allocate nodes */
		for ident in cdata.keys {
			if deleted.contains(ident) {
				continue
			}
			if let value = cdata[ident] {
				if let ninfo = KCSpriteNode.valueToNode(value: value) {
					if let node = mNodes[ident] {
						/* Allocate actions */
						let actions = allocateActions(forNode: node, nodeInfo: ninfo)
						if actions.count > 0 {
							let newact = SKAction.group(actions)
							node.run(newact)
						}
					} else {
						/* Allocate node */
						allocateNode(identifier: ident, nodeInfo: ninfo)
					}
				} else {
					CNLog(type: .Error, message: "Failed to decode value", file: #file, line: #line, function: #function)
				}
			}
		}
		/* Call super class */
		super.updateUncached(cache: cdata, deletedItems: deleted)
	}

	private func allocateNode(identifier ident: String, nodeInfo ninfo: KCSpriteNode) {
		/* Allocate node */
		let texture = SKTexture(image: ninfo.image)
		let node    = SKSpriteNode(texture: texture)
		node.name = ident
		mNodes[ident] = node
		scene.addChild(node)
		/* Update action */
		node.alpha	= CGFloat(ninfo.alpha)
		node.position 	= ninfo.position
		node.xScale	= CGFloat(ninfo.scale)
		node.yScale	= CGFloat(ninfo.scale)
		node.zRotation	= CGFloat(ninfo.rotation)
	}

	private func allocateActions(forNode node: SKNode, nodeInfo ninfo: KCSpriteNode) -> Array<SKAction> {
		var actions: Array<SKAction> = []

		if node.position != ninfo.position {
			let act = SKAction.move(to: ninfo.position, duration: ninfo.duration)
			actions.append(act)
		}
		if node.xScale != CGFloat(ninfo.scale) {
			let act = SKAction.scale(to: CGFloat(ninfo.scale), duration: ninfo.duration)
			actions.append(act)
		}
		if node.zRotation != CGFloat(ninfo.rotation) {
			let act = SKAction.rotate(toAngle: CGFloat(ninfo.rotation), duration: ninfo.duration)
			actions.append(act)
		}
		if node.alpha >= 0.5 {
			/* Visible */
			if ninfo.alpha < 0.5 {
				/* Visible -> Invisible */
				let act = SKAction.fadeOut(withDuration: ninfo.duration)
				actions.append(act)
			}
		} else {
			/* Invisible */
			if ninfo.alpha >= 0.5 {
				/* Invisible -> Visible */
				let act = SKAction.fadeIn(withDuration: ninfo.duration)
				actions.append(act)
			}
		}
		return actions
	}
}

open class KCSpriteViewCore: KCView
{
	#if os(OSX)
	@IBOutlet weak var mSpriteView: SKView!
	#else
	@IBOutlet weak var mSpriteView: SKView!
	#endif

	private var mScene: 		SKScene?			= nil
	private var mNodes: 		Dictionary<String, SKNode>	= [:]
	private var mNodeDatabase:	KCSpriteViewDatabase 		= KCSpriteViewDatabase()

	public func setup(frame frm: CGRect) {
		let scene = SKScene(size: frm.size)
		scene.scaleMode = .resizeFill

		mScene = scene
		mNodeDatabase.scene = scene
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

	public var sceneSize: CGSize {
		get { return scene.size }
	}

	public var database: CNDatabaseProtocol {
		get { return mNodeDatabase }
	}

	public var backgroundColorOfScene: KCColor {
		get 		{ return scene.backgroundColor }
		set(color) 	{ scene.backgroundColor = color }
	}
}


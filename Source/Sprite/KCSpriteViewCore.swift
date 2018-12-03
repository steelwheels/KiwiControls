/**
 * @file KCSpriteViewCore.swift
 * @brief Define KCSpriteViewCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

public class KCSpriteViewDatabase: CNDatabase
{
	private static let	ImageFileItem		= "imageFile"
	private static let	ScaleItem		= "scale"
	private static let	AlphaItem		= "alpha"
	private static let	PositionItem		= "position"
	private static let	RotationItem		= "rotation"
	private static let	DurationItem		= "duration"

	private var	mScene:		SKScene?
	private var	mNewNodes:	Dictionary<String, SKNode>
	private var	mAllNodes:	Dictionary<String, SKNode>
	private var 	mNewActions:	Dictionary<String, SKAction>

	public override init(){
		mScene		= nil
		mNewNodes	= [:]
		mAllNodes	= [:]
		mNewActions	= [:]
	}

	public var scene: SKScene {
		get {
			if let scene = mScene {
				return scene
			} else {
				fatalError("No scene")
			}
		}
		set(scene){
			mScene = scene
		}
	}

	public class func makeParameter(imageFile ifile: String,
					scale scaval: Double,
					alpha alval: Double,
					position posval: CGPoint,
					rotation rotval: Double,
					duration durval: Double) -> CNNativeValue {
		let scanum = NSNumber(value: scaval)
		let alnum  = NSNumber(value: alval)
		let rotnum = NSNumber(value: rotval)
		let durnum = NSNumber(value: durval)
		let params: Dictionary<String, CNNativeValue> = [
			ImageFileItem:		.stringValue(ifile),
			ScaleItem:		.numberValue(scanum),
			AlphaItem:		.numberValue(alnum),
			PositionItem:		.pointValue(posval),
			RotationItem:		.numberValue(rotnum),
			DurationItem:		.numberValue(durnum)
		]
		return .dictionaryValue(params)
	}

	public override func create(identifier ident: String, value val: CNNativeValue) -> Bool {
		/* Get property */
		guard let imgfile = val.stringProperty(identifier: KCSpriteViewDatabase.ImageFileItem) else {
			NSLog("No imageFile property in \(#function)")
			return false
		}
		/* Allocate SKNode */
		let node  = SKSpriteNode(imageNamed: imgfile)
		node.name = ident
		/* Apply node property */
		guard assignNodeProperty(node: node, value: val) else {
			NSLog("Failed to assign property at \(#function)")
			return false
		}
		/* Add as new node */
		mNewNodes[ident] = node
		mAllNodes[ident] = node
		return super.create(identifier: ident, value: val)
	}

	public override func read(identifier ident: String) -> CNNativeValue? {
		return super.read(identifier: ident)
	}

	public override func write(identifier ident: String, value val: CNNativeValue) -> Bool {
		if super.write(identifier: ident, value: val) {
			if let node = mAllNodes[ident] {
				let actions = allocateActions(forNode: node, value: val)
				if actions.count > 0 {
					mNewActions[ident] = SKAction.group(actions)
				}
				return true
			} else {
				NSLog("Node \(ident) is not found in \(#function)")
			}
		}
		return false
	}

	public override func delete(identifier ident: String) -> CNNativeValue? {
		return super.delete(identifier: ident)
	}

	public override func commit() {
		/* Append new node to scene */
		for (_, node) in mNewNodes {
			scene.addChild(node)
		}
		/* Run action */
		for (ident, action) in mNewActions {
			if let node = mAllNodes[ident] {
				node.run(action)
			} else {
				NSLog("No node in \(#function)")
			}
		}
		super.commit()
	}

	private func assignNodeProperty(node nod: SKNode, value val: CNNativeValue) -> Bool {
		guard let alpha = val.numberProperty(identifier: KCSpriteViewDatabase.AlphaItem) else {
			NSLog("No alpha property in \(#function)")
			return false
		}
		guard let position = val.pointProperty(identifier: KCSpriteViewDatabase.PositionItem) else {
			NSLog("No position property in \(#function)")
			return false
		}
		guard let scale = val.numberProperty(identifier: KCSpriteViewDatabase.ScaleItem) else {
			NSLog("No scale property in \(#function)")
			return false
		}
		guard let rotation = val.numberProperty(identifier: KCSpriteViewDatabase.RotationItem) else {
			NSLog("No rotation property in \(#function)")
			return false
		}

		nod.alpha	= CGFloat(alpha.doubleValue)
		nod.position 	= position
		nod.xScale	= CGFloat(scale.doubleValue)
		nod.yScale	= CGFloat(scale.doubleValue)
		nod.zRotation	= CGFloat(rotation.doubleValue)
		
		return true
	}

	private func allocateActions(forNode node: SKNode, value val: CNNativeValue) -> Array<SKAction> {
		var actions: Array<SKAction> = []

		guard let durationnum = val.numberProperty(identifier: KCSpriteViewDatabase.DurationItem) else {
			NSLog("No duration property at \(#function)")
			return []
		}
		guard let alphanum = val.numberProperty(identifier: KCSpriteViewDatabase.AlphaItem) else {
			NSLog("No alpha property at \(#function)")
			return []
		}
		guard let position = val.pointProperty(identifier: KCSpriteViewDatabase.PositionItem) else {
			NSLog("No position property at \(#function)")
			return []
		}
		guard let scalenum = val.numberProperty(identifier: KCSpriteViewDatabase.ScaleItem) else {
			NSLog("No scale property at \(#function)")
			return []
		}
		guard let rotationnum = val.numberProperty(identifier: KCSpriteViewDatabase.RotationItem) else {
			NSLog("No rotation property at \(#function)")
			return []
		}

		let duration = durationnum.doubleValue
		let alpha    = alphanum.doubleValue
		let scale    = scalenum.doubleValue
		let rotation = rotationnum.doubleValue
		
		if node.position != position {
			let act = SKAction.move(to: position, duration: duration)
			actions.append(act)
		}
		if node.xScale != CGFloat(scale) {
			let act = SKAction.scale(to: CGFloat(scale), duration: duration)
			actions.append(act)
		}
		if node.zRotation != CGFloat(rotation) {
			let act = SKAction.rotate(toAngle: CGFloat(rotation), duration: duration)
			actions.append(act)
		}
		if node.alpha >= 0.5 {
			/* Visible */
			if alpha < 0.5 {
				/* Visible -> Invisible */
				let act = SKAction.fadeOut(withDuration: duration)
				actions.append(act)
			}
		} else {
			/* Invisible */
			if alpha >= 0.5 {
				/* Invisible -> Visible */
				let act = SKAction.fadeIn(withDuration: duration)
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

	public var database: KCSpriteViewDatabase {
		get { return mNodeDatabase }
	}

	public var backgroundColorOfScene: KCColor {
		get 		{ return scene.backgroundColor }
		set(color) 	{ scene.backgroundColor = color }
	}
}


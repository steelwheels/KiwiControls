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
	private static let	PositionItem		= "positon"
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
					duration durval: Double) -> CNValue {
		let params: Dictionary<String, CNValue> = [
			ImageFileItem:		CNValue(stringValue: ifile),
			ScaleItem:		CNValue(doubleValue: scaval),
			AlphaItem:		CNValue(doubleValue: alval),
			PositionItem:		CNValue(pointValue: posval),
			RotationItem:		CNValue(doubleValue: rotval),
			DurationItem:		CNValue(doubleValue: durval)
		]
		return CNValue(dictionaryValue: params)
	}

	public override func create(identifier ident: String, value val: CNValue) -> Bool {
		/* Get property */
		guard let imgfile = stringElement(inValue: val, member: KCSpriteViewDatabase.ImageFileItem) else {
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

	public override func read(identifier ident: String) -> CNValue? {
		return super.read(identifier: ident)
	}

	public override func write(identifier ident: String, value val: CNValue) -> Bool {
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

	public override func delete(identifier ident: String) -> CNValue? {
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

	private func assignNodeProperty(node nod: SKNode, value val: CNValue) -> Bool {
		guard let alpha = doubleElement(inValue: val, member: KCSpriteViewDatabase.AlphaItem) else {
			NSLog("No alpha property in \(#function)")
			return false
		}
		guard let position = pointElement(inValue: val, member: KCSpriteViewDatabase.PositionItem) else {
			NSLog("No position property in \(#function)")
			return false
		}
		guard let scale = doubleElement(inValue: val, member: KCSpriteViewDatabase.ScaleItem) else {
			NSLog("No scale property in \(#function)")
			return false
		}
		guard let rotation = doubleElement(inValue: val, member: KCSpriteViewDatabase.RotationItem) else {
			NSLog("No rotation property in \(#function)")
			return false
		}

		nod.alpha	= CGFloat(alpha)
		nod.position 	= position
		nod.xScale	= CGFloat(scale)
		nod.yScale	= CGFloat(scale)
		nod.zRotation	= CGFloat(rotation)
		
		return true
	}

	private func allocateActions(forNode node: SKNode, value val: CNValue) -> Array<SKAction> {
		var actions: Array<SKAction> = []

		guard let duration = doubleElement(inValue: val, member: KCSpriteViewDatabase.DurationItem) else {
			NSLog("No duration property at \(#function)")
			return []
		}
		guard let alpha = doubleElement(inValue: val, member: KCSpriteViewDatabase.AlphaItem) else {
			NSLog("No alpha property at \(#function)")
			return []
		}
		guard let position = pointElement(inValue: val, member: KCSpriteViewDatabase.PositionItem) else {
			NSLog("No position property at \(#function)")
			return []
		}
		guard let scale = doubleElement(inValue: val, member: KCSpriteViewDatabase.ScaleItem) else {
			NSLog("No scale property at \(#function)")
			return []
		}
		guard let rotation = doubleElement(inValue: val, member: KCSpriteViewDatabase.RotationItem) else {
			NSLog("No rotation property at \(#function)")
			return []
		}

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

	private func stringElement(inValue value: CNValue, member memb: String) -> String? {
		if let elmval = dictionaryElement(inValue: value, member: memb) {
			if let imgstr = elmval.stringValue {
				return imgstr
			}
		}
		return nil
	}

	private func doubleElement(inValue value: CNValue, member memb: String) -> Double? {
		if let elmval = dictionaryElement(inValue: value, member: memb) {
			if let dblval = elmval.doubleValue {
				return dblval
			}
		}
		return nil
	}

	private func pointElement(inValue value: CNValue, member memb: String) -> CGPoint? {
		if let elmval = dictionaryElement(inValue: value, member: memb) {
			if let ptval = elmval.pointValue {
				return ptval
			}
		}
		return nil
	}

	private func dictionaryElement(inValue value: CNValue, member memb: String) -> CNValue? {
		if let dict = value.dictionaryValue {
			return dict[memb]
		} else {
			return nil
		}
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


/**
 * @file	KCSceneViewCore.h
 * @brief	Define KCSceneViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import SceneKit

public class KCSceneViewCore: KCView
{
	@IBOutlet weak var sceneView: SCNView!

	private var mScene	: SCNScene?	= nil
	private var mZeroNode	: SCNNode?	= nil
	private var mCameraNode	: SCNNode?	= nil
	private var mLightNode	: SCNNode?	= nil
	
	public override init(frame : NSRect){
		super.init(frame: frame)
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	public func setup(){
		let scene = SCNScene()
		sceneView.scene		= scene
		mScene			= scene
		
		let root = scene.rootNode
		
		mZeroNode	= KCSceneViewCore.allocateZeroPoint()
		root.addChildNode(mZeroNode!)
		
		mLightNode	= KCSceneViewCore.allocateLight()
		root.addChildNode(mLightNode!)
		
		mCameraNode	= KCSceneViewCore.allocateCamera(mZeroNode!)
		root.addChildNode(mCameraNode!)
	}
	
	private class func allocateZeroPoint() -> SCNNode {
		let node	= SCNNode()
		node.position	= SCNVector3Make(0.0, 0.0, 0.0)
		return node
	}
	
	private class func allocateLight() -> SCNNode {
		let node	= SCNNode()
		let light	= SCNLight()
		node.light	= light
		light.type	= SCNLightTypeOmni
		return node
	}
	
	private class func allocateCamera(zeronode: SCNNode) -> SCNNode {
		let node	= SCNNode()
		let camera	= SCNCamera()
		node.camera	= camera
		return node
	}
	
	public func addChildNode(node: SCNNode){
		if let scene = mScene {
			scene.rootNode.addChildNode(node)
		}
	}
	
	public func startAnimation() {
		sceneView.play(self)
		sceneView.loops	= true
	}
	
	public func stopAnimation(){
		sceneView.play(self)
		sceneView.loops	= false
	}

	public var delegate: SCNSceneRendererDelegate? {
		get		{ return sceneView.delegate }
		set(newval)	{ sceneView.delegate = newval }
	}
	
	public var zeroNode: SCNNode {
		get {
			if let node = mZeroNode {
				return node
			}
			fatalError("No zero node")
		}
	}
	
	public var cameraNode: SCNNode {
		get {
			if let node = mCameraNode {
				return node
			}
			fatalError("No camera node")
		}
	}
	
	public var lightNode: SCNNode {
		get {
			if let node = mLightNode {
				return node
			}
			fatalError("No light node")
		}
	}

	public var backgroundColor: NSColor {
		get {
			return sceneView.backgroundColor
		}
		set(newcolor){
			sceneView.backgroundColor = newcolor
		}
	}
}

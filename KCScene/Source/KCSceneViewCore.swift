/**
 * @file	KCSceneViewCore.h
 * @brief	Define KCSceneViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import SceneKit

public class KCSceneViewCore: KCView, SCNSceneRendererDelegate
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
		sceneView.delegate	= self
		mScene			= scene
		
		mZeroNode	= KCSceneViewCore.allocateZeroPoint()
		mLightNode	= KCSceneViewCore.allocateLight()
		mCameraNode	= KCSceneViewCore.allocateCamera(mZeroNode!)
		
		let root = scene.rootNode
		root.addChildNode(mZeroNode!)
		root.addChildNode(mLightNode!)
		root.addChildNode(mCameraNode!)
		
		//sceneView.playing	= true		/* Fource update for each frame processing */
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
		
		let constraint = SCNLookAtConstraint(target: zeronode)
		node.constraints = [constraint]
		
		return node
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
	
	public func addChildNode(node: SCNNode){
		if let scene = mScene {
			scene.rootNode.addChildNode(node)
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
	
	public func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
		Swift.print("renderer \(time)")
	}
}

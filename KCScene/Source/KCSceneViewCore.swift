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
	
	public func setup(cameraPosition: SCNVector3, lightPosition: SCNVector3){
		let scene = SCNScene()
		sceneView.scene		= scene
		sceneView.delegate	= self
		mScene			= scene
		
		mZeroNode	= KCSceneViewCore.allocateZeroPoint()
		mLightNode	= KCSceneViewCore.allocateLight(mZeroNode!)
		mCameraNode	= KCSceneViewCore.allocateCamera(mZeroNode!)
		
		mCameraNode!.position = cameraPosition
		mLightNode!.position  = lightPosition
		
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
	
	private class func allocateLight(zeronode: SCNNode) -> SCNNode {
		let node	= SCNNode()
		let light	= SCNLight()
		node.light	= light
		light.type	= SCNLightTypeOmni
		
		let constraint = SCNLookAtConstraint(target: zeronode)
		constraint.gimbalLockEnabled = true
		node.constraints = [constraint]
		
		return node
	}
	
	private class func allocateCamera(zeronode: SCNNode) -> SCNNode {
		let node	= SCNNode()
		let camera	= SCNCamera()
		node.camera	= camera
		
		let constraint = SCNLookAtConstraint(target: zeronode)
		constraint.gimbalLockEnabled = true
		node.constraints = [constraint]
		
		return node
	}
	
	public var cameraNode: SCNNode {
		get {
			if let node = mCameraNode {
				return node
			} else {
				fatalError("No camera node")
			}
		}
	}
	
	public var lightNode: SCNNode {
		get {
			if let node = mLightNode {
				return node
			} else {
				fatalError("No light node")
			}
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

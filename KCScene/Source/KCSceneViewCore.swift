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
	private var mFarNode	: SCNNode?	= nil
	private var mCameraNode	: SCNNode?	= nil
	private var mLightNode	: SCNNode?	= nil

	public override init(frame : NSRect){
		super.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public func setup(nearPoint: SCNVector3, farPoint: SCNVector3){
		let scene = SCNScene()
		sceneView.scene		= scene
		mScene			= scene

		let root = scene.rootNode

		let farnode		= SCNNode()
		farnode.position	= SCNVector3(farPoint.x, farPoint.y, farPoint.z)
		mFarNode		= farnode
		
		mLightNode	= KCSceneViewCore.allocateLight(nearPoint)
		root.addChildNode(mLightNode!)

		mCameraNode	= KCSceneViewCore.allocateCamera(nearPoint, targetNode: farnode)
		root.addChildNode(mCameraNode!)
	}

	private class func allocateLight(position: SCNVector3) -> SCNNode {
		let node	= SCNNode()
		let light	= SCNLight()
		node.light	= light
		node.position	= SCNVector3(position.x, position.y, position.z)
		light.type	= SCNLightTypeOmni
		return node
	}

	private class func allocateCamera(sourcePosition: SCNVector3, targetNode: SCNNode) -> SCNNode {
		let node	= SCNNode()
		let camera	= SCNCamera()
		node.camera	= camera
		node.lookAt(targetNode)
		node.position	= SCNVector3(sourcePosition.x, sourcePosition.y, sourcePosition.z)

		/* get max distance */
		let diffpt = sourcePosition - targetNode.position
		camera.zNear = 1.0
		camera.zFar  = Double(diffpt.length())

		return node
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

	public var rootNode: SCNNode {
		get {
			if let scene = mScene {
				return scene.rootNode
			}
			fatalError("No root node")
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

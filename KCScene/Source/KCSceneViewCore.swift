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
	private var mCameraNode	: SCNNode?	= nil
	private var mLightNode	: SCNNode?	= nil

	public override init(frame : NSRect){
		super.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public func setup(nearPoint: KCPoint3, farPoint: KCPoint3){
		let scene = SCNScene()
		sceneView.scene		= scene
		mScene			= scene

		let root = scene.rootNode

		mLightNode	= KCSceneViewCore.allocateLight(nearPoint)
		root.addChildNode(mLightNode!)

		mCameraNode	= KCSceneViewCore.allocateCamera(nearPoint, targetPosition: farPoint)
		root.addChildNode(mCameraNode!)
	}

	private class func allocateLight(position: KCPoint3) -> SCNNode {
		let node	= SCNNode()
		let light	= SCNLight()
		node.light	= light
		node.position	= SCNVector3(position.x, position.y, position.z)
		light.type	= SCNLightTypeOmni
		return node
	}

	private class func allocateCamera(sourcePosition: KCPoint3, targetPosition: KCPoint3) -> SCNNode {
		let node	= SCNNode()
		let camera	= SCNCamera()
		node.position	= SCNVector3(sourcePosition.x, sourcePosition.y, sourcePosition.z)
		node.camera	= camera
		node.lookAt(SCNVector3(targetPosition.x, targetPosition.y, targetPosition.z))

		/* get max distance */
		let diffpt = sourcePosition - targetPosition
		camera.zNear = 1.0
		camera.zFar  = Double(diffpt.length())

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

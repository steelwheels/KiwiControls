/**
 * @file	KCSceneViewCore.h
 * @brief	Define KCSceneViewCore class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import KCControls
import KCGraphics
import SceneKit

public class KCSceneViewCore: KCView
{
	@IBOutlet weak var sceneView: SCNView!

	private var mScene			: SCNScene?	= nil
	private var mCameraDestinationNode	: SCNNode?	= nil
	private var mCameraSourceNode		: SCNNode?	= nil
	private var mLightNode			: SCNNode?	= nil

	public override init(frame f: NSRect){
		super.init(frame: f)
	}

	public required init?(coder c: NSCoder) {
		super.init(coder: c)
	}

	public func setup(lightPoint lp: KCPoint3, cameraPoint cp: KCLine3){
		let scene = SCNScene()
		sceneView.scene		= scene
		mScene			= scene

		let root = scene.rootNode

		let lightorigin = KCPoint3ToVector3(lp)
		mLightNode	= KCSceneViewCore.allocateLight(position: lightorigin)
		root.addChildNode(mLightNode!)

		let (camerasrc, cameradst) = KCSceneViewCore.allocateCamera(cameraPoint: cp)
		root.addChildNode(camerasrc)
		root.addChildNode(cameradst)
		mCameraSourceNode = camerasrc
		mCameraDestinationNode = cameradst
	}

	private class func allocateLight(position pos: SCNVector3) -> SCNNode {
		let node	= SCNNode()
		let light	= SCNLight()
		node.light	= light
		node.position	= SCNVector3(pos.x, pos.y, pos.z)
		light.type	= SCNLightTypeOmni
		return node
	}

	private class func allocateCamera(cameraPoint cp: KCLine3) -> (SCNNode, SCNNode) {
		let frompt = KCPoint3ToVector3(cp.fromPoint)
		let topt   = KCPoint3ToVector3(cp.toPoint)

		/* Allocate target */
		let dstnode	 = SCNNode()
		dstnode.position = topt

		/* Allocate source */
		let srcnode	= SCNNode()
		let camera	= SCNCamera()
		srcnode.camera	= camera
		srcnode.lookAt(target: dstnode)
		srcnode.position = frompt

		/* get max distance */
		let diffpt = frompt - topt
		camera.zNear = 1.0
		camera.zFar  = Double(diffpt.length())

		return (srcnode, dstnode)
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

	public var cameraSourceNode: SCNNode {
		get {
			if let node = mCameraSourceNode {
				return node
			}
			fatalError("No camera source node")
		}
	}

	public var cameraDestionationNode: SCNNode {
		get {
			if let node = mCameraDestinationNode {
				return node
			}
			fatalError("No camera destination node")
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

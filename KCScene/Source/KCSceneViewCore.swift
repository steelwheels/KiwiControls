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
	
	private var mScene	: SCNScene? = nil
	private var mCameraNode	: SCNNode?  = nil
	private var mLightNode	: SCNNode?  = nil
	
	public override init(frame : NSRect){
		super.init(frame: frame)
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	public func setup(){
		let scene = SCNScene()
		sceneView.scene = scene
		
		let camera = SCNNode()
		camera.camera = SCNCamera()
		scene.rootNode.addChildNode(camera)
		camera.position = SCNVector3(x: 0.0, y:0.0, z:5.0)
		
		let lightnode = SCNNode()
		let light     = SCNLight()
		lightnode.light    = light
		light.type         = SCNLightTypeOmni
		lightnode.position = SCNVector3(x:0.0, y:0.0, z:10.0)
		scene.rootNode.addChildNode(lightnode)
		
		mScene		= scene
		mCameraNode	= camera
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
}

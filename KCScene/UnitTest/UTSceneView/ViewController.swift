//
//  ViewController.swift
//  UTSceneView
//
//  Created by Tomoo Hamada on 2016/04/20.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KCControls
import KCScene
import SceneKit
import Canary

class ViewController: NSViewController, SCNSceneRendererDelegate
{
	@IBOutlet weak var sceneView: KCSceneView!

	override func viewDidLoad() {
		super.viewDidLoad()
		let nearpt = SCNVector3(x: 100.0, y: 100.0, z: 100.0)
		let farpt  = SCNVector3(x:-100.0, y:-100.0, z:-100.0)

		sceneView.setup(nearpt, farPoint: farpt)
		sceneView.delegate = self

		let console = CNTextConsole()

		// Do any additional setup after loading the view.
		sceneView.backgroundColor = NSColor.blueColor()

/*
		let floor0 = SCNNode()
		floor0.geometry = SCNFloor()
		floor0.position = SCNVector3(x: 0.0, y:0.0, z:0.0)
		floor0.geometry?.firstMaterial?.diffuse.contents = NSColor.whiteColor()
		sceneView.addChildNode(floor0)
*/

		let sphere0 = SCNNode()
		sphere0.geometry = SCNSphere(radius: 50.0)
		sphere0.position = SCNVector3(0.0, 0.0, 0.0)
		sceneView.addChildNode(sphere0)

/*
		let box0 = SCNNode()
		box0.geometry = SCNBox(width:20, height:10, length:100, chamferRadius:0.02)
		box0.position = SCNVector3(x: 20, y:0.0, z:0.0)
		sceneView.addChildNode(box0)

		let box1 = SCNNode()
		box1.geometry = SCNBox(width:20, height:10, length:100, chamferRadius:0.02)
		box1.position = SCNVector3(x: -20, y:0.0, z:0.0)
		sceneView.addChildNode(box1)

		let cone2 = SCNNode()
		cone2.geometry = SCNCone(topRadius: 2.0, bottomRadius: 10.0, height: 50.0)
		cone2.position = SCNVector3(x: -30, y:0.0, z:0.0)
		cone2.lookAt(SCNVector3(0.0, 0.0, 0.0))
		sceneView.addChildNode(cone2)
*/
		//let camera = sceneView.cameraNode
		//let light  = sceneView.lightNode
		//camera.position	= SCNVector3(x: 0.0, y: 100.0, z: 100.0)
		//light.position	= SCNVector3(x: 0.0, y: 100.0, z: 100.0)
		//camera.lookAt(SCNVector3(0.0, 0.0, 0.0))

		Swift.print("[Camera]")
		sceneView.cameraNode.dumpToConsole(console)

		sceneView.startAnimation()
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	internal func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
	}
}


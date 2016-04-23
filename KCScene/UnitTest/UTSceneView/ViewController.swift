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
		sceneView.setup()
		sceneView.delegate = self
		
		let console = CNTextConsole()
		
		// Do any additional setup after loading the view.
		sceneView.backgroundColor = NSColor.blueColor()
		
		let box0 = SCNNode()
		box0.geometry = SCNBox(width:10, height:10, length:10, chamferRadius:0.02)
		box0.position = SCNVector3(x: 20, y:0.0, z:0.0)
		sceneView.addChildNode(box0)
		
		let box1 = SCNNode()
		box1.geometry = SCNBox(width:10, height:10, length:10, chamferRadius:0.02)
		box1.position = SCNVector3(x: -20, y:0.0, z:0.0)
		sceneView.addChildNode(box1)
		
		let camera = sceneView.cameraNode
		let light  = sceneView.lightNode
		camera.position	= SCNVector3(x: 0.0, y: 0.0, z: 100.0)
		light.position	= SCNVector3(x: 0.0, y: 0.0, z: 1000.0)
		
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


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

class ViewController: NSViewController
{
	@IBOutlet weak var sceneView: KCSceneView!

	override func viewDidLoad() {
		super.viewDidLoad()

		sceneView.setup(SCNVector3(x: 0.0, y: 0.0, z: 100.0),
		                lightPosition: SCNVector3(x: 0.0, y: 0.0, z: 100.0))
		
		// Do any additional setup after loading the view.
		sceneView.backgroundColor = NSColor.blackColor()
		
		let boxNode = SCNNode()
		boxNode.geometry = SCNBox(width:50, height:50, length:50, chamferRadius:0.02)
		sceneView.addChildNode(boxNode)
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}


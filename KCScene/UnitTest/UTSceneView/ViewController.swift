//
//  ViewController.swift
//  UTSceneView
//
//  Created by Tomoo Hamada on 2016/04/20.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KCControls
import KCScene

class ViewController: NSViewController
{
	@IBOutlet weak var sceneView: KCSceneView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		sceneView.backgroundColor = NSColor.blackColor()
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}


//
//  ViewController.swift
//  UTGraphicsPrimitive
//
//  Created by Tomoo Hamada on 2016/12/08.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls
import KiwiGraphics

class ViewController: UIViewController
{
	@IBOutlet weak var mGraphicsView: UTGraphicsView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		mGraphicsView.setup(bounds: bounds)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


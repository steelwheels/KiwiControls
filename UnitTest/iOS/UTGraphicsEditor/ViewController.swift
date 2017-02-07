//
//  ViewController.swift
//  UTGraphicsEditor
//
//  Created by Tomoo Hamada on 2016/11/27.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls
import KiwiGraphics

class ViewController: UIViewController
{
	@IBOutlet weak var mGraphicsView: KCLayerView!

	override func viewDidLoad() {
       
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	public override func viewDidLayoutSubviews() {
		Swift.print("View did layout")

		let bounds = mGraphicsView.bounds
		let frame  = mGraphicsView.frame
		Swift.print("mGraphicsView: frame=\(frame.description), bounds=\(bounds.description)")
		let stroke = KCStrokeEditorLayer(frame: bounds)
		stroke.backgroundColor = KGColorTable.blue.cgColor
		mGraphicsView.rootLayer.addSublayer(stroke)
	}

    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}




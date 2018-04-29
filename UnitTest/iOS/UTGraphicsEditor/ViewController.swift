/**
 * @file	ViewController.swift
 * @brief	Define ViewController class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

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
		stroke.backgroundColor = KCColorTable.blue.cgColor
		mGraphicsView.rootLayer.addSublayer(stroke)
	}

    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}




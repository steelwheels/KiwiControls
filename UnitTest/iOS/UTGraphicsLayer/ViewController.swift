//
//  ViewController.swift
//  UTGraphicsLayer
//
//  Created by Tomoo Hamada on 2016/10/14.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import UIKit
import KiwiControls

class ViewController: UIViewController
{
	@IBOutlet weak var mGraphicsView: KCGraphicsView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib
		let bounds = mGraphicsView.bounds
		Swift.print("**** Bounds0: \(bounds.description)")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let bounds = mGraphicsView.bounds
		Swift.print("**** Bounds1: \(bounds.description)")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


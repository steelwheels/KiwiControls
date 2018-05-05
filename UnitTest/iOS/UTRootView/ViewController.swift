//
//  ViewController.swift
//  UTRootView
//
//  Created by Tomoo Hamada on 2018/05/05.
//  Copyright © 2018年 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var mRootView: KCRootView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		let button = KCButton()
		mRootView.setupContext(childView: button)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


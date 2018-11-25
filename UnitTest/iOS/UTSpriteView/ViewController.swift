//
//  ViewController.swift
//  UTSpriteView
//
//  Created by Tomoo Hamada on 2018/11/22.
//  Copyright © 2018 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var mSpriteView: KCSpriteView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mSpriteView.backgroundColorOfScene = .yellow

		let b0init = KCNodeStatus(isVisible: true, position: KCPoint(x:10.0, y:10.0), scale: 0.5, rotation: 0.0)
		mSpriteView.addNode(name: "b0", imageNamed: "blue-machine", status: b0init)

		let b0stat = KCNodeStatus(isVisible: true, position: KCPoint(x:100.0, y:100.0), scale: 0.5, rotation: 3.14159*2.0/4.0)
		mSpriteView.set(nodeName: "b0", status: b0stat, durationTime: 1.0)

		let g0init = KCNodeStatus(isVisible: true, position: KCPoint(x:110.0, y:110.0), scale: 0.5, rotation: 0.0)
		mSpriteView.addNode(name: "g0", imageNamed: "green-machine", status: g0init)

		let g0stat = KCNodeStatus(isVisible: true, position: KCPoint(x:200.0, y:200.0), scale: 0.5, rotation: 3.14159*2.0/4.0)
		mSpriteView.set(nodeName: "g0", status: g0stat, durationTime: 1.0)
	}


}


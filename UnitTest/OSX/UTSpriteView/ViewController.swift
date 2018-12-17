//
//  ViewController.swift
//  UTSpriteView
//
//  Created by Tomoo Hamada on 2018/11/22.
//  Copyright © 2018 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import CoconutData
import Cocoa

class ViewController: NSViewController {

	@IBOutlet weak var mSpriteView: KCSpriteView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		mSpriteView.backgroundColorOfScene = .yellow

		let db = mSpriteView.database

		let b0init = KCSpriteNode(imageFile: "blue-machine",
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x:10.0, y:10.0),
					  rotation: 0.0,
					  duration: 1.0)
		let _ = db.write(identifier: "b0", value: b0init.toValue())

		let g0init = KCSpriteNode(imageFile: "green-machine",
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x:470.0, y:200.0),
					  rotation: 0.0,
					  duration: 1.0)
		let _ = db.write(identifier: "g0", value: g0init.toValue())

		/* Update the database */
		db.commit()
		
		let b0param = KCSpriteNode(imageFile: "blue-machine",
					   scale: 0.5,
					   alpha: 1.0,
					   position: CGPoint(x:240.0, y:50.0),
					   rotation: Double.pi * 2.0 / 4.0,
					   duration: 1.0)
		let _ = db.write(identifier: "b0", value: b0param.toValue())

		let g0param = KCSpriteNode(imageFile: "green-machine",
					   scale: 0.5,
					   alpha: 1.0,
					   position: CGPoint(x:240.0, y:150.0),
					   rotation: -Double.pi * 2.0 / 4.0,
					   duration: 1.0)
		let _ = db.write(identifier: "g0", value: g0param.toValue())

		/* Update the database */
		db.commit()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}


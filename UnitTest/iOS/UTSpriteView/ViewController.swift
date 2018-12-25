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

		let b0init = KCSpriteNode(imageFile: "blue-machine",
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 10.0, y: 10.0),
					  rotation: 0.0,
					  duration: 1.0)
		mSpriteView.database.write(identifier: "b0", value: b0init.toValue())

		let g0init = KCSpriteNode(imageFile: "green-machine",
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 370.0, y: 650.0),
					  rotation: 0.0,
					  duration: 1.0)
		mSpriteView.database.write(identifier: "g0", value: g0init.toValue())

		mSpriteView.database.commit()

		let b0param = KCSpriteNode(imageFile: "blue-machine",
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 190.0, y: 320.0),
					  rotation: 0.0,
					  duration: 1.0)
		mSpriteView.database.write(identifier: "b0", value: b0param.toValue())

		let g0param = KCSpriteNode(imageFile: "green-machine",
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 170.0, y: 340.0),
					  rotation: 0.0,
					  duration: 1.0)
		mSpriteView.database.write(identifier: "g0", value: g0param.toValue())

		mSpriteView.database.commit()

		/* Update the database */
		mSpriteView.database.commit()
	}


}


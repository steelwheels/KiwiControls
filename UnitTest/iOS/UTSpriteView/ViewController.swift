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

		let b0init = KCSpriteViewDatabase.makeParameter(imageFile: "blue-machine",
								scale: 0.5,
								alpha: 1.0,
								position: CGPoint(x:10.0, y:10.0),
								rotation: 0.0,
								duration: 1.0)
		if !mSpriteView.database.create(identifier: "b0", value: b0init) {
			NSLog("Failed to create (b0)")
		}

		let g0init = KCSpriteViewDatabase.makeParameter(imageFile: "green-machine",
								scale: 0.5,
								alpha: 1.0,
								position: CGPoint(x:370.0, y:650.0),
								rotation: 0.0,
								duration: 1.0)
		if !mSpriteView.database.create(identifier: "g0", value: g0init) {
			NSLog("Failed to create (g0)")
		}

		let b0param = KCSpriteViewDatabase.makeParameter(imageFile: "blue-machine",
								 scale: 0.5,
								 alpha: 1.0,
								 position: CGPoint(x:190.0, y:320.0),
								 rotation: Double.pi * 2.0 / 4.0,
								 duration: 1.0)
		if !mSpriteView.database.write(identifier: "b0", value: b0param) {
			NSLog("Failed to write (b0)")
		}

		let g0param = KCSpriteViewDatabase.makeParameter(imageFile: "green-machine",
								 scale: 0.5,
								 alpha: 1.0,
								 position: CGPoint(x:210.0, y:340.0),
								 rotation: -Double.pi * 2.0 / 4.0,
								 duration: 1.0)
		if !mSpriteView.database.write(identifier: "g0", value: g0param) {
			NSLog("Failed to write (g0)")
		}

		/* Update the database */
		mSpriteView.database.commit()
	}


}


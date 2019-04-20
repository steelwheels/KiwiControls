//
//  ViewController.swift
//  UTSpriteView
//
//  Created by Tomoo Hamada on 2018/11/22.
//  Copyright © 2018 Steel Wheels Project. All rights reserved.
//

import CoconutData
import KiwiControls
import UIKit

class ViewController: UIViewController
{
	@IBOutlet weak var mSpriteView: KCSpriteView!

	override func viewDidLoad() {
		super.viewDidLoad()

		let cons = KCLogConsole.shared

		guard let blueurl = CNFilePath.URLForResourceFile(fileName: "blue-machine", fileExtension: "png") else {
			NSLog("Can not decide URL for blue-machine")
			return
		}
		guard let blueimage = CNImage(contentsOf: blueurl) else {
			NSLog("Can not load blue-machine")
			return
		}

		guard let greenurl = CNFilePath.URLForResourceFile(fileName: "green-machine", fileExtension: "png") else {
			NSLog("Can not decide URL for green-machine")
			return
		}
		guard let greenimage = CNImage(contentsOf: greenurl) else {
			NSLog("Can not load green-machine")
			return
		}

		// Do any additional setup after loading the view.
		mSpriteView.backgroundColorOfScene = .yellow

		let b0init = KCSpriteNode(image: blueimage,
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 10.0, y: 10.0),
					  rotation: 0.0,
					  duration: 1.0,
					  console:  cons)
		mSpriteView.database.write(identifier: "b0", value: b0init.toValue())

		let g0init = KCSpriteNode(image: greenimage,
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 370.0, y: 650.0),
					  rotation: 0.0,
					  duration: 1.0,
					  console:  cons)
		mSpriteView.database.write(identifier: "g0", value: g0init.toValue())

		mSpriteView.database.commit()

		let b0param = KCSpriteNode(image: blueimage,
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 190.0, y: 320.0),
					  rotation: 0.0,
					  duration: 1.0,
					  console:  cons)
		mSpriteView.database.write(identifier: "b0", value: b0param.toValue())

		let g0param = KCSpriteNode(image: greenimage,
					  scale: 0.5,
					  alpha: 1.0,
					  position: CGPoint(x: 170.0, y: 340.0),
					  rotation: 0.0,
					  duration: 1.0,
					  console:  cons)
		mSpriteView.database.write(identifier: "g0", value: g0param.toValue())

		mSpriteView.database.commit()

		/* Update the database */
		mSpriteView.database.commit()
	}


}


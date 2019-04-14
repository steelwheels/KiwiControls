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

class ViewController: NSViewController, CNLogging
{
	public var console: CNLogConsole? = nil

	@IBOutlet weak var mSpriteView: KCSpriteView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		/* Allocate cosole */
		console = CNLogConsole(debugLevel: .Flow, toConsole: KCLogConsole.shared)
		log(type: .Flow, string: "Message from ViewController", file: #file, line: #line, function: #function)
		mSpriteView.console = console

		guard let blueurl = CNFilePath.URLForResourceFile(fileName: "blue-machine", fileExtension: "png") else {
			log(type: .Error, string: "Can not decide URL for blue-machine", file: #file, line: #line, function: #function)
			return
		}
		guard let blueimage = CNImage(contentsOf: blueurl) else {
			log(type: .Error, string: "Can not load blue-machine", file: #file, line: #line, function: #function)
			return
		}

		guard let greenurl = CNFilePath.URLForResourceFile(fileName: "green-machine", fileExtension: "png") else {
			log(type: .Error, string: "Can not decide URL for green-machine", file: #file, line: #line, function: #function)
			return
		}
		guard let greenimage = CNImage(contentsOf: greenurl) else {
			log(type: .Error, string: "Can not load green-machine", file: #file, line: #line, function: #function)
			return
		}

		// Do any additional setup after loading the view.
		mSpriteView.backgroundColorOfScene = .yellow

		let db = mSpriteView.database

		let b0init = KCSpriteNode(image:    blueimage,
					  scale:    0.5,
					  alpha:    1.0,
					  position: CGPoint(x:10.0, y:10.0),
					  rotation: 0.0,
					  duration: 1.0,
					  console:  console)
		let _ = db.write(identifier: "b0", value: b0init.toValue())

		let g0init = KCSpriteNode(image:    greenimage,
					  scale:    0.5,
					  alpha:    1.0,
					  position: CGPoint(x:470.0, y:200.0),
					  rotation: 0.0,
					  duration: 1.0,
					  console:  console)
		let _ = db.write(identifier: "g0", value: g0init.toValue())

		/* Update the database */
		db.commit()
		
		let b0param = KCSpriteNode(image:    blueimage,
					   scale:    0.5,
					   alpha:    1.0,
					   position: CGPoint(x:240.0, y:50.0),
					   rotation: Double.pi * 2.0 / 4.0,
					   duration: 1.0,
					   console:  console)
		let _ = db.write(identifier: "b0", value: b0param.toValue())

		let g0param = KCSpriteNode(image:    greenimage,
					   scale:    0.5,
					   alpha:    1.0,
					   position: CGPoint(x:240.0, y:150.0),
					   rotation: -Double.pi * 2.0 / 4.0,
					   duration: 1.0,
					   console:  console)
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


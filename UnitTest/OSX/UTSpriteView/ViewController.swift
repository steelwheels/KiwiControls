//
//  ViewController.swift
//  UTSpriteView
//
//  Created by Tomoo Hamada on 2018/11/22.
//  Copyright © 2018 Steel Wheels Project. All rights reserved.
//

import KiwiControls
import SpriteKit
import CoconutData
import Cocoa

class ViewController: NSViewController, CNLogging
{
	private var mConsole: CNConsole? = nil

	@IBOutlet weak var mSpriteView: KCSpriteView!

	public var console: CNConsole? {
		get { return mConsole }
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		/* Allocate cosole */
		let cons = KCLogConsole.shared
		mConsole = cons

		log(type: .Flow, string: "Message from ViewController", file: #file, line: #line, function: #function)
		mSpriteView.set(console: cons)

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

		/* Set actions */
		mSpriteView.contactEndHandler = {
			[weak self] (_ point: CGPoint, _ nodeA: KCSpriteNode?, _ nodeB: KCSpriteNode?) -> Void in
			if let myself = self {
				myself.updateActions(contactAt: point, nodeA: nodeA, nodeB: nodeB, console: myself.mConsole!)
			}
		}
		
		/* allocate nodes */
		let b0status = KCSpriteNodeStatus(size: CGSize(width: 0.2, height: 0.2), position: CGPoint(x: 0.1, y: 0.51))
		let b0node   = mSpriteView.allocate(nodeName: "B0", image: blueimage, initStatus: b0status)
		let g0status = KCSpriteNodeStatus(size: CGSize(width: 0.2, height: 0.2), position: CGPoint(x: 0.9, y: 0.49))
		let g0node   = mSpriteView.allocate(nodeName: "G0", image: greenimage, initStatus: g0status)

		/* allocate action */
		let b0action = KCSpriteNodeAction(visible: true, speed: 0.3, angle: CGFloat.pi / 2.0)
		b0node.action = b0action

		let g0action = KCSpriteNodeAction(visible: true, speed: 0.3, angle: -(CGFloat.pi / 2.0))
		g0node.action = g0action
	}

	private func updateActions(contactAt point: CGPoint, nodeA na: KCSpriteNode?, nodeB nb: KCSpriteNode?, console cons: CNConsole) {
		if let nodeA = na {
			cons.print(string: "Node-A: ")
			let text = nodeA.toValue().toText()
			text.print(console: cons)

			/* Update action */
			cons.print(string: "Action-A: ")
			var act = nodeA.action
			//let txt2 = act.toValue().toText()
			//txt2.print(console: cons)
			act.angle += CGFloat.pi / 8.0
			nodeA.action = act
		} else {
			cons.error(string: "No node-A\n")
		}
		if let nodeB = nb {
			cons.print(string: "Node-B: ")
			let text = nodeB.toValue().toText()
			text.print(console: mConsole!)

			/* Update action */
			var act = nodeB.action
			//let txt2 = act.toValue().toText()
			//txt2.print(console: cons)
			act.angle -= CGFloat.pi / 8.0
			nodeB.action = act
		} else {
			cons.error(string: "No node-B\n")
		}
	}
}


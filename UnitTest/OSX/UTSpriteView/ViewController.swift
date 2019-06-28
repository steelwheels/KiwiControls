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

class UTSpriteOpetation: CNOperationContext {
	open override func main() {
		let res = KCSpriteOperationContext.execute(context: self, updateFunction: {
			(_ status: KCSpriteNodeStatus, _ action: KCSpriteNodeAction) -> KCSpriteNodeAction? in
			let newact = KCSpriteNodeAction(active:  action.active,
							speed:   action.speed,
							angle:   action.angle)
			return newact

		})
		if !res {
			if let cons = console {
				cons.print(string: "Failed to execute\n")
			}
		}
	}
}


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
		mSpriteView.didContactHandler = {
			[weak self] (_ point: CGPoint, _ operationA: CNOperationContext?, _ operationB: CNOperationContext?) -> Void in
			if let myself = self {
				myself.updateActions(contactAt: point, operationA: operationA, operationB: operationB, console: myself.mConsole!)
			}
		}
		
		/* allocate nodes */
		let b0ctxt   = UTSpriteOpetation(console: cons)
		let b0status = KCSpriteNodeStatus(size: CGSize(width: 0.2, height: 0.2), position: CGPoint(x: 0.1, y: 0.1), energy: 1.0)
		let b0action = KCSpriteNodeAction(active: true, speed: 0.5, angle: CGFloat.pi * 3.0 / 4.0)
		let b0node   = mSpriteView.allocate(nodeName: "B0", image: blueimage, initStatus: b0status, initAction: b0action, context: b0ctxt)
		let g0ctxt   = UTSpriteOpetation(console: cons)
		let g0status = KCSpriteNodeStatus(size: CGSize(width: 0.2, height: 0.2), position: CGPoint(x: 0.9, y: 0.9), energy: 1.0)
		let g0action = KCSpriteNodeAction(active: true, speed: 0.5, angle: -(CGFloat.pi / 4.0))
		let g0node   = mSpriteView.allocate(nodeName: "G0", image: greenimage, initStatus: g0status, initAction: g0action, context: g0ctxt)
	}

	open override func viewWillAppear() {
		/* Resize window */
		NSLog("viewWillAppear")
		if let window = self.view.window {
			let pref = CNPreference.shared
			let size = pref.windowPreference.mainWindowSize
			window.resize(size: size)
			NSLog("resize window: size=\(size.description)")
		}
	}

	private func updateActions(contactAt point: CGPoint, operationA opA: CNOperationContext?, operationB opB: CNOperationContext?, console cons: CNConsole) {

		if let opA = opA {
			if let name = KCSpriteOperationContext.getName(context: opA) {
				cons.print(string: "Node-A: \(name)\n")
			} else {
				cons.print(string: "Node-A: <Unknown>\n")
			}
		} else {
			cons.error(string: "No node-A\n")
		}
		if let opB = opB {
			if let name = KCSpriteOperationContext.getName(context: opB) {
				cons.print(string: "Node-B: \(name)\n")
			} else {
				cons.print(string: "Node-B: <Unknown>\n")
			}
		} else {
			cons.error(string: "No node-B\n")
		}
	}
}


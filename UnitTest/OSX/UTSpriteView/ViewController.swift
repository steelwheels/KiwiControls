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
			(_ interval: TimeInterval, _ status: KCSpriteNodeStatus, _ radar: KCSpriteRadar, _ action: KCSpriteNodeAction) -> KCSpriteNodeAction? in
			let newact = KCSpriteNodeAction(speed: action.speed, angle: action.angle)
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

		/* Set condition */
		let wallcond = KCSpriteCondition(givingCollisionDamage: 0.05, receivingCollisionDamage: 0.05, raderRange: KCSpriteCondition.NoRange)
		mSpriteView.wallCondition = wallcond

		/* Set actions */
		mSpriteView.contactObserverHandler = {
			[weak self] (_ point: CGPoint, _ status: KCSpriteNodeStatus) -> Void in
			if let myself = self {
				myself.updateActions(contactAt: point, status: status, console: myself.mConsole!)
			}
		}
		
		/* allocate nodes */
		//let lsize    = CGSize(width: 480.0, height: 270.0)
		//mSpriteView.logicalSize = lsize
		let lsize    = mSpriteView.setLogicalSizeWithKeepingAspectRatio(width: 100.0)

		let nodesize = CGSize(width: lsize.height*0.1, height: lsize.height*0.1)
		let nodebnds = CGRect(origin: CGPoint.zero, size: mSpriteView.logicalSize)

		let b0ctxt   = UTSpriteOpetation(console: cons)
		let b0status = KCSpriteNodeStatus(name: "B0", teamId: 0, size: nodesize, position: CGPoint(x: lsize.width * 0.1, y: lsize.height * 0.1), bounds: nodebnds, energy: 1.0)
		let b0action = KCSpriteNodeAction(speed: 20.0, angle: CGFloat.pi * 0.60)
		let b0cond   = KCSpriteCondition(givingCollisionDamage: 0.05, receivingCollisionDamage: 0.05, raderRange: KCSpriteCondition.NoRange)
		let _        = mSpriteView.allocate(nodeName: "B0", image: blueimage, initStatus: b0status, initAction: b0action, condition: b0cond, context: b0ctxt)


		let g0ctxt   = UTSpriteOpetation(console: cons)
		let g0status = KCSpriteNodeStatus(name: "G0", teamId: 1, size: nodesize, position: CGPoint(x: lsize.width * 0.9, y: lsize.height * 0.9), bounds: nodebnds, energy: 1.0)
		let g0action = KCSpriteNodeAction(speed: 20.0, angle: CGFloat.pi * 1.40)
		let g0cond   = KCSpriteCondition(givingCollisionDamage: 0.05, receivingCollisionDamage: 0.05, raderRange: KCSpriteCondition.NoRange)
		let _        = mSpriteView.allocate(nodeName: "G0", image: greenimage, initStatus: g0status, initAction: g0action, condition: g0cond, context: g0ctxt)

		/* Start action */
		mSpriteView.isPaused = false
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

	private func updateActions(contactAt point: CGPoint, status stat: KCSpriteNodeStatus, console cons: CNConsole) {
		let energy = stat.energy
		let opname = stat.name
		cons.print(string: "Conflict \(opname): energy=\(energy)\n")
	}
}


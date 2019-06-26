/**
 * @file KCSpriteViewCore.swift
 * @brief Define KCSpriteViewCore class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

open class KCSpriteViewCore: KCView
{
	#if os(OSX)
	@IBOutlet weak var mSpriteView: SKView!
	#else
	@IBOutlet weak var mSpriteView: SKView!
	#endif

	private var mScene: 		KCSpriteScene?				 = nil
	private var mNodes: 		Dictionary<String, KCSpriteNode>	 = [:]

	public func setup(frame frm: CGRect) {
		let scene       = KCSpriteScene(frame: frm, console: console)
		scene.scaleMode = .aspectFill
		
		mScene = scene
		mSpriteView.presentScene(mScene)
	}

	private var scene: KCSpriteScene {
		if let scene = mScene {
			return scene
		} else {
			fatalError("Can not happen")
		}
	}

	public func logicalSize() -> KCSize {
		return scene.logicalSize()
	}

	public var backgroundColorOfScene: KCColor {
		get        { return scene.backgroundColor }
		set(newcol){ scene.backgroundColor = newcol }
	}

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteNodeStatus, context ctxt: CNOperationContext) -> KCSpriteNode {
		return scene.allocate(nodeName: name, image: img, initStatus: istat, context: ctxt)
	}

	public var didContactHandler: KCSpriteScene.ContactHandler? {
		get { return scene.didContactHandler }
		set(newhdl) { scene.didContactHandler = newhdl }
	}

	public var becomeEmptyHandler: KCSpriteScene.BecomeEmptyHandler? {
		get { return scene.becomeEmptyHandler }
		set(newhdl) { scene.becomeEmptyHandler = newhdl }
	}

	open override func sizeThatFits(_ size: CGSize) -> CGSize {
		return size
	}

	open override var intrinsicContentSize: KCSize {
		if hasFixedSize {
			return super.intrinsicContentSize
		} else {
			return scene.size
		}
	}

	open override func resize(_ size: KCSize){
		if let view = mSpriteView {
			view.frame.size  = size
			view.bounds.size = size
		}
		scene.resize(sceneSize: size)
		super.resize(size)
	}
}


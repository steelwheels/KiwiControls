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
		KCView.setAutolayoutMode(views: [self, mSpriteView])

		let scene       = KCSpriteScene(frame: frm)
		scene.scaleMode = .aspectFill
		
		mScene = scene
		mSpriteView.presentScene(mScene)
		scene.isPaused = true
	}

	private var scene: KCSpriteScene {
		if let scene = mScene {
			return scene
		} else {
			fatalError("Can not happen")
		}
	}

	public var logicalSize: CGSize {
		get { return scene.logicalSize }
		set(newsize) { scene.logicalSize = newsize }
	}

	public func setLogicalSizeWithKeepingAspectRatio(width val: CGFloat) -> CGSize {
		return scene.setLogicalSizeWithKeepingAspectRatio(width: val)
	}

	public var backgroundColorOfScene: CNColor {
		get        { return scene.backgroundColor }
		set(newcol){ scene.backgroundColor = newcol }
	}

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteStatus, initAction iact: KCSpriteNodeAction, condition cond: KCSpriteCondition, context ctxt: CNOperationContext?) -> KCSpriteNode {
		return scene.allocate(nodeName: name, image: img, initStatus: istat, initAction: iact, condition: cond, context: ctxt)
	}

	public var isPaused: Bool {
		get { return scene.isPaused }
		set(newval) { scene.isPaused = newval }
	}

	public var damageByWall: Double {
		get { return scene.damageByWall }
		set(newval) { scene.damageByWall = newval }
	}

	public var contactObserverHandler: KCSpriteScene.ContactObserverHandler? {
		get { return scene.contactObserverHandler }
		set(newhdl) { scene.contactObserverHandler = newhdl }
	}

	public var continuationCheckerHandler: KCSpriteScene.ContinuationCheckerHandler? {
		get { return scene.continuationCheckerHandler }
		set(newhdl) { scene.continuationCheckerHandler = newhdl }
	}

	open override var fittingSize: KCSize {
		get {
			return scene.size
		}
	}

	open override var intrinsicContentSize: KCSize {
		if hasFixedSize {
			return super.intrinsicContentSize
		} else {
			return scene.size
		}
	}

	public override func setExpandability(holizontal holiz: KCViewBase.ExpansionPriority, vertical vert: KCViewBase.ExpansionPriority) {
		mSpriteView.setExpansionPriority(holizontal: holiz, vertical: vert)
		super.setExpandability(holizontal: holiz, vertical: vert)
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


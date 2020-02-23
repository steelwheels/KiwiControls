/**
 * @file KCSpriteView.swift
 * @brief Define KCSpriteView class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
import SpriteKit
import Foundation

open class KCSpriteView: KCCoreView
{
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame)
		setup(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame)
		setup(frame: frame)
	}
	#endif

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 188, height: 21)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup(frame: self.frame)
	}

	private func setup(frame frm: CGRect){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCSpriteView.self, nibName: "KCSpriteViewCore") as? KCSpriteViewCore {
			setCoreView(view: newview)
			newview.setup(frame: frm)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCSpriteViewCore")
		}
	}

	public var logicalSize: CGSize {
		get { return coreView.logicalSize }
		set(newsize) { coreView.logicalSize = newsize }
	}

	public func setLogicalSizeWithKeepingAspectRatio(width val: CGFloat) -> CGSize {
		return coreView.setLogicalSizeWithKeepingAspectRatio(width: val)
	}

	open override func expansionPriorities() -> (ExpansionPriority /* Holiz */, ExpansionPriority /* Vert */) {
		return (.High, .High)
	}

	#if false
	public func setColors(colors cols: KCColorPreference.ButtonColors){
		coreView.setColors(colors: cols)
		#if os(iOS)
		self.backgroundColor = cols.background.normal
		#endif
	}
	#endif

	public func allocate(nodeName name: String, image img: CNImage, initStatus istat: KCSpriteStatus, initAction iact: KCSpriteNodeAction, condition cond: KCSpriteCondition, context ctxt: CNOperationContext?) -> KCSpriteNode {
		return coreView.allocate(nodeName: name, image: img, initStatus: istat, initAction: iact, condition: cond, context: ctxt)
	}

	public var isPaused: Bool {
		get { return coreView.isPaused }
		set(newval) { coreView.isPaused = newval }
	}

	public var damageByWall: Double {
		get { return coreView.damageByWall }
		set(newval) { coreView.damageByWall = newval }
	}

	public var contactObserverHandler: KCSpriteScene.ContactObserverHandler? {
		get { return coreView.contactObserverHandler }
		set(newhdl) { coreView.contactObserverHandler = newhdl }
	}

	public var continuationCheckerHandler: KCSpriteScene.ContinuationCheckerHandler? {
		get { return coreView.continuationCheckerHandler }
		set(newhdl) { coreView.continuationCheckerHandler = newhdl }
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(spriteView: self)
	}

	public var backgroundColorOfScene: KCColor {
		get 		{ return coreView.backgroundColorOfScene	}
		set(color) 	{ coreView.backgroundColorOfScene = color	}
	}

	private var coreView : KCSpriteViewCore {
		get { return getCoreView() }
	}
}

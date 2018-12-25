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
		if let newview = loadChildXib(thisClass: KCSpriteView.self, nibName: "KCSpriteViewCore") as? KCSpriteViewCore {
			setCoreView(view: newview)
			newview.setup(frame: frm)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCSpriteViewCore")
		}
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

	public var database: CNDatabaseProtocol {
		get { return coreView.database }
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

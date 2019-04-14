/**
 * @file	KCRootView.swift
 * @brief	Define KCRootView class
 * @par Copyright
 *   Copyright (C) 2018 Steel Wheels Project
 */

import CoconutData
#if os(OSX)
import Cocoa
#else
import UIKit
#endif

open class KCRootView: KCCoreView
{
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
	}
	#endif

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 480, height: 272)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 256, height: 256)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
	}

	public func setup(childView child: KCView){
		self.addSubview(child)
		setCoreView(view: child)
		child.console = self.console
		#if os(iOS)
			self.backgroundColor = KCPreference.shared.layoutPreference.backgroundColor
		#endif
	}

	public override var console: CNLogConsole? {
		get {
			return super.console
		}
		set(cons){
			for subview in self.subviews {
				if var cview = subview as? CNLogging {
					cview.console = cons
				}
			}
			super.console = cons
		}
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(rootView: self)
	}
}


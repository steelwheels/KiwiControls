/**
 * @file KCPopupMenu.swift
 * @brief Define KCPopupMenu class
 * @par Copyright
 *   Copyright (C) 2020 Steel Wheels Project
 */

#if os(OSX)
import Cocoa
#else
import UIKit
#endif
import CoconutData

open class KCPopupMenu : KCInterfaceView
{
	public typealias CallbackFunction = KCPopupMenuCore.CallbackFunction

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setup() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setup()
	}
	#endif

	public convenience init(){
		#if os(OSX)
		let frame = NSRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#else
		let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 60)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setup() ;
	}

	private func setup(){
		KCView.setAutolayoutMode(view: self)
		if let newview = loadChildXib(thisClass: KCPopupMenuCore.self, nibName: "KCPopupMenuCore") as? KCPopupMenuCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
		} else {
			fatalError("Can not load KCPopupMenuCore")
		}
	}

	public var callbackFunction: CallbackFunction? {
		get { return coreView.callbackFunction }
		set(newfunc) { coreView.callbackFunction = newfunc }
	}
	
	public var indexOfSelectedItem: Int {
		get { return coreView.indexOfSelectedItem }
	}

	public var titleOfSelectedItem: String? {
		get { return coreView.titleOfSelectedItem }
	}

	public func itemTitles() -> Array<String> {
		return coreView.itemTitles()
	}

	public func addItems(withTitles titles: Array<String>) {
		coreView.addItems(withTitles: titles)
	}

	public func removeAllItems() {
		coreView.removeAllItems()
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(popupMenu: self)
	}

	private var coreView: KCPopupMenuCore {
		get { return getCoreView() }
	}
}


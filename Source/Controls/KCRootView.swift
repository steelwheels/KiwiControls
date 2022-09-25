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

open class KCRootView: KCInterfaceView
{
	private var mViewListners:	Array<CNObserverDictionary.ListnerHolder>
	private var mSystemListners:	Array<CNObserverDictionary.ListnerHolder>

	#if os(OSX)
	public override init(frame : NSRect){
		mViewListners	= []
		mSystemListners	= []
		super.init(frame: frame) ;
		self.wantsLayer = true
	}
	#else
	public override init(frame: CGRect){
		mViewListners	= []
		mSystemListners	= []
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
		mViewListners	= []
		mSystemListners	= []
		super.init(coder: coder) ;
		#if os(OSX)
		self.wantsLayer = true
		#endif
	}

	deinit {
		/* Remove color observer */
		let vpref = CNPreference.shared.viewPreference
		for holder in mViewListners {
			vpref.removeObserver(listnerHolder: holder)
		}
		let spref = CNPreference.shared.systemPreference
		for holder in mSystemListners {
			spref.removeObserver(listnerHolder: holder)
		}
	}

	public func setup(childView child: KCView, edgeInsets insets: KCEdgeInsets){
		KCView.setAutolayoutMode(view: self)

		self.addSubview(child)
		super.allocateSubviewLayout(subView: child, in: insets)
		setCoreView(view: child)

		let vpref = CNPreference.shared.viewPreference
		setBackgroundColor(color: vpref.backgroundColor)

		/* Add color observer */
		mViewListners.append(
			vpref.addObserver(forKey: vpref.BackgroundColorItem, listnerFunction: {
				(_ param: Any?) -> Void in
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in self.setBackgroundColor(color: vpref.backgroundColor)
				})
			})
		)
		let spref = CNPreference.shared.systemPreference
		mSystemListners.append(
			spref.addObserver(forKey: CNSystemPreference.InterfaceStyleItem, listnerFunction: {
				(_ param: Any?) -> Void in
				CNExecuteInMainThread(doSync: false, execute: {
					() -> Void in self.setBackgroundColor(color: vpref.backgroundColor)
				})
			})
		)
	}

	public func setBackgroundColor(color col: CNColor) {
		#if os(OSX)
		if let layer = self.layer {
			layer.backgroundColor = col.cgColor
		}
		#else
		self.backgroundColor = col
		#endif
	}

	open override func accept(visitor vis: KCViewVisitor){
		vis.visit(rootView: self)
	}
}


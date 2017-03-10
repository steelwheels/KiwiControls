/**
 * @file	KCIconView.swift
 * @brief	Define KCIconView class
 * @par Copyright
 *   Copyright (C) 017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import KiwiGraphics

open class KCIconView: KCView
{
	private var mCoreView: KCIconViewCore? = nil

	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame) ;
		setupContext() ;
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame) ;
		setupContext()
	}
	#endif

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let coreview = loadChildXib(thisClass: KCIconView.self, nibName: "KCIconViewCore") as? KCIconViewCore {
			mCoreView = coreview
			coreview.setup()
		} else {
			fatalError("Can not load KCIconViewCore")
		}
	}

	public var imageDrawer: KGImageDrawer? {
		get {
			if let coreview = mCoreView {
				return coreview.imageDrawer
			} else {
				return nil
			}
		}
		set(drawer){
			if let coreview = mCoreView {
				coreview.imageDrawer = drawer
			}
		}
	}

	public var label: String {
		get {
			if let coreview = mCoreView {
				return coreview.label
			} else {
				return ""
			}
		}
		set(str){
			if let coreview = mCoreView {
				coreview.label = str
			}
		}
	}

	private func coreView() -> KCIconViewCore {
		if let coreview = mCoreView {
			return coreview
		} else {
			fatalError("No core view")
		}
	}

	/*
	public final override func observe(state stat: CNState){
		if let decen = decideEnableCallback {
			if let doenable = decen(stat) {
				coreView().isEnabled = doenable
			}
		}
		if let decvis = decideVisibleCallback {
			if let dovis = decvis(stat) {
				coreView().isVisible = dovis
			}
		}
	}

	public func setColors(colors cols: KGColorPreference.ButtonColors){
		coreView().setColors(colors: cols)
		#if os(iOS)
			self.backgroundColor = cols.background.normal
		#endif
	}
*/
}

/**
 * @file	KCButton.swift
 * @brief	Define KCButton class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import Canary
import KiwiGraphics

open class KCButton: KCView
{
	public var decideEnableCallback : ((_: CNState) -> Bool?)? = nil
	public var decideVisibleCallback: ((_: CNState) -> Bool?)? = nil

	public var buttonPressedCallback: (() -> Void)? {
		get { return coreView().buttonPressedCallback }
		set(callback){ coreView().buttonPressedCallback = callback }
	}

	public var title: String {
		get { return coreView().title }
		set(newstr){ coreView().title = newstr }
	}

	private var mCoreView: KCButtonCore? = nil

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
		if let coreview = loadChildXib(thisClass: KCButton.self, nibName: "KCButtonCore") as? KCButtonCore {
			mCoreView = coreview
			coreview.setup()
		} else {
			fatalError("Can not load KCButtonCore")
		}
	}

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
	}
	
	private func coreView() -> KCButtonCore {
		if let coreview = mCoreView {
			return coreview
		} else {
			fatalError("No core view")
		}
	}
}


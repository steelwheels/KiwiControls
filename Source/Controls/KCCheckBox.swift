/**
 * @file	KCCheckBox.swift
 * @brief	Define KCCheckBox class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import Canary

open class KCCheckBox: KCView
{
	public var decideEnableCallback : ((_: CNState) -> Bool?)? = nil
	public var decideVisibleCallback: ((_: CNState) -> Bool?)? = nil

	public var checkUpdatedCallback: ((_ value: Bool) -> Void)? {
		get { return coreView().checkUpdatedCallback }
		set(callback){ coreView().checkUpdatedCallback = callback }
	}

	public var title: String {
		get { return coreView().title }
		set(newstr){ coreView().title = newstr }
	}

	private var mCoreView: KCCheckBoxCore? = nil

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
		if let coreview = loadChildXib(thisClass: KCCheckBox.self, nibName: "KCCheckBoxCore") as? KCCheckBoxCore {
			mCoreView = coreview
			coreview.setup()
		} else {
			fatalError("Can not load KCCheckBoxCore")
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

	private func coreView() -> KCCheckBoxCore {
		if let coreview = mCoreView {
			return coreview
		} else {
			fatalError("No core view")
		}
	}
}


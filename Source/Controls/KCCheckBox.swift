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

	public var checkUpdatedCallback: ((_ value: Bool) -> Void)? {
		get { return coreView().checkUpdatedCallback }
		set(callback){ coreView().checkUpdatedCallback = callback }
	}

	public var title: String {
		get { return coreView().title }
		set(newstr){ coreView().title = newstr }
	}

	public var isEnabled: Bool {
		get { return coreView().isEnabled }
		set(v) { coreView().isEnabled = v }
	}

	public var isVisible: Bool {
		get { return coreView().isVisible }
		set(v) { coreView().isVisible = v }
	}

	private func coreView() -> KCCheckBoxCore {
		if let coreview = mCoreView {
			return coreview
		} else {
			fatalError("No core view")
		}
	}
}


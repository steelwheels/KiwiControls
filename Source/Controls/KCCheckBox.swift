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

open class KCCheckBox: KCCoreView
{
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
		if let newview = loadChildXib(thisClass: KCCheckBox.self, nibName: "KCCheckBoxCore") as? KCCheckBoxCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
		} else {
			fatalError("Can not load KCCheckBoxCore")
		}
	}

	public var checkUpdatedCallback: ((_ value: Bool) -> Void)? {
		get { return coreView.checkUpdatedCallback }
		set(callback){ coreView.checkUpdatedCallback = callback }
	}

	public var title: String {
		get { return coreView.title }
		set(newstr){ coreView.title = newstr }
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var isVisible: Bool {
		get { return coreView.isVisible }
		set(v) { coreView.isVisible = v }
	}

	private var coreView: KCCheckBoxCore {
		get { return getCoreView() }
	}
}


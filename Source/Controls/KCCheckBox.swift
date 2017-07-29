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

	public convenience init(){
		#if os(OSX)
			let frame = NSRect(x: 0.0, y: 0.0, width: 156, height: 16)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 200, height: 32)
		#endif
		self.init(frame: frame)
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCCheckBox.self, nibName: "KCCheckBoxCore") as? KCCheckBoxCore {
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
			setCoreView(view: newview)
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


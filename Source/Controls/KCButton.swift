/**
 * @file	KCButton.swift
 * @brief	Define KCButton class
 * @par Copyright
 *   Copyright (C) 2016-2017 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import Canary
import KiwiGraphics

open class KCButton: KCCoreView
{
	#if os(OSX)
	public override init(frame : NSRect){
		super.init(frame: frame)
		setupContext(frame: frame)
	}
	#else
	public override init(frame: CGRect){
		super.init(frame: frame)
		setupContext(frame: frame)
	}
	#endif

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupContext(frame: self.frame)
	}

	private func setupContext(frame frm: CGRect){
		if let newview = loadChildXib(thisClass: KCButton.self, nibName: "KCButtonCore") as? KCButtonCore {
			newview.setup(frame: frm)
			allocateSubviewLayout(subView: newview)
			setCoreView(view: newview)
		} else {
			fatalError("Can not load KCButtonCore")
		}
	}

	public var buttonPressedCallback: (() -> Void)? {
		get { return coreView.buttonPressedCallback }
		set(callback){ coreView.buttonPressedCallback = callback }
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var isVisible: Bool {
		get { return coreView.isVisible }
		set(v) { coreView.isVisible = v }
	}

	public var title: String {
		get { return coreView.title }
		set(newstr){ coreView.title = newstr }
	}

	public func setColors(colors cols: KGColorPreference.ButtonColors){
		coreView.setColors(colors: cols)
		#if os(iOS)
			self.backgroundColor = cols.background.normal
		#endif
	}

	private var coreView : KCButtonCore {
		get { return getCoreView() }
	}
}


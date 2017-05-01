/**
 * @file KCStackView.swift
 * @brief Define KCStackView class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#else
	import UIKit
#endif
import KiwiGraphics
import Canary

open class KCStackView : KCCoreView
{
	public enum Axis {
		case Holizontal
		case Vertical
	}

	public enum Alignment {
		case Leading
		case Center
		case Trailing
	}

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
		if let newview = loadChildXib(thisClass: KCStackView.self, nibName: "KCStackViewCore") as? KCStackViewCore {
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
			setCoreView(view: newview)
		} else {
			fatalError("Can not load KCStackCore")
		}
	}

	public var axis: Axis {
		get		{ return coreView.axis }
		set(newval)	{ coreView.axis = newval }
	}

	public var alignment: Alignment {
		get		{ return coreView.alignment }
		set(newval)	{ coreView.alignment = newval }
	}

	public func setViews(views vs:Array<KCView>){
		coreView.setViews(views: vs)
	}

	private var coreView: KCStackViewCore {
		get { return getCoreView() }
	}
}


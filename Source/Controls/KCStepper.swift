/**
 * @file	KCStepper.swift
 * @brief	Define KCStepper class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation

public class KCStepper: KCView
{
	private var mCoreView: KCStepperCore? = nil

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
		if let coreview = loadChildXib(thisClass: KCStepper.self, nibName: "KCStepperCore") as? KCStepperCore {
			mCoreView = coreview
			coreview.setup()
		} else {
			fatalError("Can not load KCTimerViewCore")
		}
	}

	public var maxValue: Double {
		get { return coreView().maxValue }
		set(newval) { coreView().maxValue = newval }
	}

	public var minValue: Double {
		get { return coreView().minValue }
		set(newval) { coreView().minValue = newval }
	}

	public var currentValue: Double {
		get { return coreView().currentValue }
		set(newval){ coreView().currentValue = newval}
	}

	public var increment: Double {
		get { return coreView().increment }
		set(newval) { coreView().increment = newval }
	}

	public var numberOfDecimalPlaces: Int {
		get { return coreView().numberOfDecimalPlaces }
		set(newval) { coreView().numberOfDecimalPlaces = newval }
	}

	public var updateValueCallback: ((_ newvalue: Double) -> Void)? {
		get { return coreView().updateValueCallback }
		set(newval){ coreView().updateValueCallback = newval }
	}
	
	private func coreView() -> KCStepperCore {
		if let coreview = mCoreView {
			return coreview
		} else {
			fatalError("No core view")
		}
	}
}

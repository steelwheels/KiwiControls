/**
 * @file	KCStepper.swift
 * @brief	Define KCStepper class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import Canary

public class KCStepper: KCCoreView
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
			let frame = NSRect(x: 0.0, y: 0.0, width: 163, height: 34)
		#else
			let frame = CGRect(x: 0.0, y: 0.0, width: 375, height: 29)
		#endif
		self.init(frame: frame)
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder) ;
		setupContext() ;
	}

	private func setupContext(){
		if let newview = loadChildXib(thisClass: KCStepper.self, nibName: "KCStepperCore") as? KCStepperCore {
			setCoreView(view: newview)
			newview.setup(frame: self.frame)
			allocateSubviewLayout(subView: newview)
			setPriorityToResistAutoResize(priority: .HighPriority)
		} else {
			fatalError("Can not load KCStepperCore")
		}
	}

	public var updateValueCallback: ((_ newvalue: Double) -> Void)? {
		get { return coreView.updateValueCallback }
		set(newval){ coreView.updateValueCallback = newval }
	}

	public var isEnabled: Bool {
		get { return coreView.isEnabled }
		set(v) { coreView.isEnabled = v }
	}

	public var isVisible: Bool {
		get { return coreView.isVisible }
		set(v) { coreView.isVisible = v }
	}

	public var maxValue: Double {
		get { return coreView.maxValue }
		set(newval) { coreView.maxValue = newval }
	}

	public var minValue: Double {
		get { return coreView.minValue }
		set(newval) { coreView.minValue = newval }
	}

	public var currentValue: Double {
		get { return coreView.currentValue }
		set(newval){ coreView.currentValue = newval}
	}

	public var increment: Double {
		get { return coreView.increment }
		set(newval) { coreView.increment = newval }
	}

	public var numberOfDecimalPlaces: Int {
		get { return coreView.numberOfDecimalPlaces }
		set(newval) { coreView.numberOfDecimalPlaces = newval }
	}

	private var coreView: KCStepperCore {
		get { return getCoreView() }
	}
}

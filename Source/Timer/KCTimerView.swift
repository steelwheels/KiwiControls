/**
 * @file	KCTimerView.swift
 * @brief	Define KCTimerView class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

#if os(OSX)
	import Cocoa
#endif
import Canary

open class KCTimerView : KCView
{
	private var	mCoreView : KCTimerViewCore?	= nil

	private var coreView: KCTimerViewCore {
		get {
			if let cview = mCoreView {
				return cview
			} else {
				fatalError("No core view")
			}
		}
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
		if let coreview = loadChildXib(thisClass: KCTimerView.self, nibName: "KCTimerViewCore") as? KCTimerViewCore {
			mCoreView = coreview
			mCoreView?.timerValue = nil ; /* Clear label */
		} else {
			fatalError("Can not load KCTimerViewCore")
		}
	}

	open override func observe(state stat: CNState){
		if let timstate = stat as? KCTimerState {
			switch timstate.timerState {
			  case .idle, .stop:
				//Do nothing
				//coreView.timerValue = nil
			  break
			  case .work:
				coreView.timerValue = timstate.currentTime
			  break
			}
		} else {
			fatalError("Invalid state object")
		}
	}
}

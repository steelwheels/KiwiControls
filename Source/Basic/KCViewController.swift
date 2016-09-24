/**
 * @file	KCViewController.swift
 * @brief	Define KCViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

#if os(iOS)
	import UIKit
#else
	import Cocoa
#endif
import Canary

#if os(iOS)
	public typealias KCViewControllerBase = UIViewController
#else
	public typealias KCViewControllerBase = NSViewController
#endif

open class KCViewController : KCViewControllerBase
{
	private dynamic var mState: CNState?   = nil

	deinit {
		if let state = mState {
			state.remove(stateObserver: self)
		}
	}
	
	public var state : CNState? {
		get {
			return mState
		}
		set(newstate) {
			if let orgstate = mState {
				orgstate.remove(stateObserver: self)
			}
			mState = newstate
			if let state = newstate {
				state.add(stateObserver: self)
			}
		}
	}

	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				observe(state: state)
			}
		}
	}
	
	open func observe(state s: CNState){
		/* Do nothing (Override this method) */
	}

	#if os(OSX)
	public var currentContext : CGContext? {
		get {
			return NSGraphicsContext.current()?.cgContext
		}
	}
	#endif
}

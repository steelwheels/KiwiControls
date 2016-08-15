/**
 * @file	KCViewController.h
 * @brief	Define KCViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa
import Canary

public class KCViewController : NSViewController
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
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let state = object as? CNState {
			if keyPath == CNState.stateKey {
				observeState(state)
			}
		}
	}
	
	public func observeState(state : CNState){
		/* Do nothing (Override this method) */
	}
}

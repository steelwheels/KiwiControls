/**
 * @file	KCViewController.h
 * @brief	Define KCViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCViewController : NSViewController
{
	private dynamic var mState: KCState?   = nil

	deinit {
		if let state = mState {
			state.removeStateObserver(self)
		}
	}
	
	public var state : KCState? {
		get {
			return mState
		}
		set(newstate) {
			if let orgstate = mState {
				orgstate.removeStateObserver(self)
			}
			mState = newstate
			if let state = newstate {
				state.addStateObserver(self)
			}
		}
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let state = object as? KCState {
			if keyPath == KCState.stateKey() {
				observeState(state)
			}
		}
	}
	
	public func observeState(state : KCState){
		/* Do nothing (Override this method) */
	}
}

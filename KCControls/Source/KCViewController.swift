/**
 * @file	KCViewController.h
 * @brief	Define KCViewController class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Cocoa

public class KCViewController : NSViewController
{
	private var mState : KCState? = nil
	private class var stateKey : String { get{ return "mState" }}
	
	deinit {
		if let currentstate = mState {
			currentstate.removeObserver(self, forKeyPath: KCViewController.stateKey, context: nil)
		}
	}
	
	public var state : KCState? {
		get {
			return mState
		}
		set (newstate) {
			if let nextstate = newstate {
				nextstate.addObserver(self, forKeyPath: KCViewController.stateKey, options: NSKeyValueObservingOptions.New, context: nil)
				mState = nextstate
			} else {
				if let currentstate = mState {
					currentstate.removeObserver(self, forKeyPath: KCViewController.stateKey, context: nil)
				}
				mState = nil
			}
		}
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let manager = object as? KCState {
			if keyPath == KCViewController.stateKey {
				observeState(manager)
			}
		}
	}
	
	public func observeState(state : KCState){
		/* Do nothing (Override this method) */
	}
}

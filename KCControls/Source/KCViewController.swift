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
		removeObserver(self, forKeyPath: "mState", context: nil)
	}
	
	public var state : KCState? {
		get		{ return mState		}
		set(newstate)	{ mState = newstate	}
	}
	
	public func addStateObserver(observer: NSObject){
		self.addObserver(observer, forKeyPath: "mState", options: .New, context: nil)
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let manager = object as? KCViewController {
			if keyPath == "mState" {
				if let state = manager.state {
					observeState(state)
				}
			}
		}
	}
	
	public func observeState(state : KCState){
		/* Do nothing (Override this method) */
	}
}

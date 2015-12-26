/*
 * @file	KCState.h
 * @brief	Define KCState class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class KCState : NSObject
{
	public class var stateKey : String { get{ return "mState" }}
	
	public class func setStateObserver(target: NSObject, currentState: KCState?, newState: KCState?) {
		/* Remove current observer */
		if let curstate = currentState {
			curstate.removeObserver(target, forKeyPath: KCState.stateKey)
		}
		/* Set new observer */
		if let newstate = newState {
			newstate.addObserver(target, forKeyPath: KCState.stateKey, options: .New, context: nil)
		}
	}
}

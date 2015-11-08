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
	
	public func addObserverOfState(observer : NSObject){
		self.addObserver(observer, forKeyPath: KCState.stateKey, options: NSKeyValueObservingOptions.New, context: nil)
	}
	
	public func removeObserverOfState(observer : NSObject){
		self.removeObserver(observer, forKeyPath: KCState.stateKey)
	}
}

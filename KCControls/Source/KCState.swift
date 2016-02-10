/*
 * @file	KCState.h
 * @brief	Define KCState class
 * @par Copyright
 *   Copyright (C) 2015 Steel Wheels Project
 */

import Foundation

public class KCState : NSObject
{
	private dynamic var mStateId = 0
	
	public func addStateObserver(observer: NSObject){
		self.addObserver(observer, forKeyPath: KCState.stateKey(), options: .New, context: nil)
	}
	
	public func removeStateObserver(observer: NSObject){
		self.removeObserver(observer, forKeyPath: KCState.stateKey())
	}
	
	public func updateState() -> Void {
		self.mStateId += 1
	}
	
	public class func stateKey() -> String {
		return "mStateId"
	}
}

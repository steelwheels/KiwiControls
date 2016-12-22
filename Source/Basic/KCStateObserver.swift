/**
 * @file	KCStateObserver.swift
 * @brief	Define KCStateObserver class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Canary

public func KCDeinitObserver(state st: CNState?, observer obs: NSObject)
{
	if let state = st {
		state.remove(stateObserver: obs)
	}
}

public func KCReplaceState(originalState orgstat: CNState?, newState newstat: CNState?, observer obs: NSObject) -> CNState?
{
	if let os = orgstat {
		os.remove(stateObserver: obs)
	}
	if let ns = newstat {
		ns.add(stateObserver: obs)
	}
	return newstat
}

public func KCDidStateUpdated(forKeyPath keyPath: String?, of object: Any?) -> CNState?
{
	var result: CNState? = nil
	if let state = object as? CNState {
		if keyPath == CNState.stateKey {
			result = state
		}
	}
	return result
}

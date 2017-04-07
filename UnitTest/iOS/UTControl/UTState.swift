/**
 * @file	UTState.swift
 * @brief	Unit test for CNState class
 * @par Copyright
 *   Copyright (C) 2017 Steel Wheels Project
 */

import Foundation
import Canary

public enum UTProgress {
	case Init
	case Step1
	case Step2
}

public class UTState: CNState
{
	public enum Factor: Int {
		case Progress
	}

	private var mProgress: UTProgress = .Init

	public var progress: UTProgress {
		get { return mProgress }
		set(newprogress){
			mProgress = newprogress
			self.updateState(factorValue: Factor.Progress.rawValue)
		}
	}
}

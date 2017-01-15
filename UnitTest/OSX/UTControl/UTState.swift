//
//  UTState.swift
//  KiwiControls
//
//  Created by Tomoo Hamada on 2016/12/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

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

	public var factor: Factor {
		get {
			if let f = Factor(rawValue: factorValue) {
				return f
			} else {
				fatalError("Invalid factorValue")
			}
		}
	}

	public var progress: UTProgress {
		get { return mProgress }
		set(newprogress){
			mProgress = newprogress
			self.updateState(factorValue: Factor.Progress.rawValue)
		}
	}
}


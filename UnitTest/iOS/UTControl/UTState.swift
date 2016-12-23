//
//  UTState.swift
//  KiwiControls
//
//  Created by Tomoo Hamada on 2016/12/24.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation

import Canary

public enum UTProgress {
	case Init
	case Step1
	case Step2
}

public class UTState: CNState
{
	private var mProgress: UTProgress = .Init

	public var progress: UTProgress {
		get { return mProgress }
		set(newprogress){
			mProgress = newprogress
			self.updateState()
		}
	}
}

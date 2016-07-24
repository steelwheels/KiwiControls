//
//  UTState.swift
//  KCControls
//
//  Created by Tomoo Hamada on 2016/07/24.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import Canary

public enum UTStateId {
	case InvalidValueState
	case ValidValueState
}

public class UTState: CNState
{
	var stateId: UTStateId = .InvalidValueState
	
	public func setValid(flag: Bool){
		if flag {
			stateId = .ValidValueState
			updateState()
		} else {
			if stateId != .InvalidValueState {
				stateId = .InvalidValueState
				updateState()
			}
		}
	}
}
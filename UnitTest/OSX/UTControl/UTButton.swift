//
//  UTButton.swift
//  KiwiControls
//
//  Created by Tomoo Hamada on 2016/12/23.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import KiwiControls
import Canary

public class UTButton: KCButton
{
	open override func updateEnable(state: CNState) -> Bool? {
		Swift.print("update enable")
		return nil
	}

	open override func updateTitle(state: CNState) -> String? {
		var result: String? = nil
		if let s = state as? UTState {
			switch s.progress {
			case .Init:
				result = "Init"
			case .Step1:
				result = "Step1"
			case .Step2:
				result = "Step2"
			}
		}
		return result
	}
}

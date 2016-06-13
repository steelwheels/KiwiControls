//
//  UTVelocity.swift
//  KCGraphics
//
//  Created by Tomoo Hamada on 2016/06/12.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Foundation
import CoreGraphics
import KCConsoleView
import KCGraphics

public class UTVelocity {
	private var mConsole: KCConsole
	
	public init(console: KCConsole){
		mConsole = console
	}
	
	public func executeTest() -> Bool {
		let v00 = KCVelocity(x: 10.0, y: 10.0)
		mConsole.print(string: "v00 = \(v00.longDescription)\n")
		
		let v01 = KCVelocity(x: 10.0, y:-10.0)
		mConsole.print(string: "v01 = \(v01.longDescription)\n")
		
		let v02 = KCVelocity(x:  0.0, y:10.0)
		mConsole.print(string: "v02 = \(v02.longDescription)\n")
		
		let v03 = KCVelocity(x: 10.0, y: 0.0)
		mConsole.print(string: "v03 = \(v03.longDescription)\n")
		
		let PI = CGFloat(M_PI)
		
		let v10 = KCVelocity(v: 10.0, angle: 0.0 * PI)
		mConsole.print(string: "v10 = \(v10.longDescription)\n")
		
		let v11 = KCVelocity(v: 10.0, angle: 0.25 * PI)
		mConsole.print(string: "v11 = \(v11.longDescription)\n")
		
		let v12 = KCVelocity(v: 10.0, angle: 0.5 * PI)
		mConsole.print(string: "v12 = \(v12.longDescription)\n")
		
		let v13 = KCVelocity(v: 10.0, angle: 1.5 * PI)
		mConsole.print(string: "v13 = \(v13.longDescription)\n")
		
		return true
	}
}

//
//  UTReflection.swift
//  KCGraphics
//
//  Created by Tomoo Hamada on 2016/05/17.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import KCGraphics
import KCConsoleView

public class UTReflection
{
	private var mConsole: KCConsole
	
	public init(console: KCConsole){
		mConsole = console
	}
	
	public func executeTest() -> Bool
	{
		mConsole.print(string: "[Test Reflection]\n")
		
		var result = true
		result = testReflection(10.0,        positionA: CGPointMake(0.1, 0.1), velocityA: KCVelocity(x: 1.0, y:  1.0),
		                        massB: 10.0, positionB: CGPointMake(0.9, 0.9), velocityB: KCVelocity(x:-1.0, y: -1.0)) && result
		result = testReflection(10.0,        positionA: CGPointMake(0.0, 0.5), velocityA: KCVelocity(x: 0.0, y:  1.0),
		                        massB: 10.0, positionB: CGPointMake(0.5, 0.0), velocityB: KCVelocity(x: 1.0, y:  0.0)) && result
		if result {
			mConsole.print(string: "[RESULT] OK\n")
		} else {
			mConsole.print(string: "[RESULT] Error\n")
		}
		return result
	}
	
	private func testReflection(
		massA:CGFloat, positionA:CGPoint, velocityA:KCVelocity,
		massB:CGFloat, positionB:CGPoint, velocityB:KCVelocity
	) -> Bool
	{
		let (refVelocityA, refVelocityB) = KCIntersect2.calculateRefrectionVelocity(
			massA, positionA: positionA, velocityA: velocityA, refrectionRateA: 1.0,
			massB: massB, positionB: positionB, velocityB: velocityB, refrectionRateB: 1.0)
		
		let vADesc = velocityA.longDescription
		let vBDesc = velocityB.longDescription
		let rADesc = refVelocityA.longDescription
		let rBDesc = refVelocityB.longDescription
		mConsole.print(string: "A: \(vADesc) -> \(rADesc), B: \(vBDesc) -> \(rBDesc)\n")
		return true
	}
}


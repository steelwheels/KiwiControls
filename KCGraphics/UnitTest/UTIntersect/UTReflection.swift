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
		result = testReflection(10.0,        positionA: CGPointMake(0.1, 0.1), velocityA: CGPointMake( 1.0,  1.0),
		                        massB: 10.0, positionB: CGPointMake(0.9, 0.9), velocityB: CGPointMake(-1.0, -1.0)) && result
		result = testReflection(10.0,        positionA: CGPointMake(0.0, 0.5), velocityA: CGPointMake( 0.0,  1.0),
		                        massB: 10.0, positionB: CGPointMake(0.5, 0.0), velocityB: CGPointMake( 1.0,  0.0)) && result
		if result {
			mConsole.print(string: "[RESULT] OK\n")
		} else {
			mConsole.print(string: "[RESULT] Error\n")
		}
		return result
	}
	
	private func testReflection(
		massA:CGFloat, positionA:CGPoint, velocityA:CGPoint,
		massB:CGFloat, positionB:CGPoint, velocityB:CGPoint
	) -> Bool
	{
		let (refVelocityA, refVelocityB) = KCIntersect2.calculateRefrectionVelocity(
			massA, positionA: positionA, velocityA: velocityA, refrectionRateA: 1.0,
			massB: massB, positionB: positionB, velocityB: velocityB, refrectionRateB: 1.0)
		
		let vADesc = velocityA.description
		let vBDesc = velocityB.description
		let rADesc = refVelocityA.description
		let rBDesc = refVelocityB.description
		mConsole.print(string: "A: \(vADesc) -> \(rADesc), B: \(vBDesc) -> \(rBDesc)\n")
		return true
	}
}

/*
public class func calculateRefrectionVelocity (
	massA			: CGFloat,
	positionA		: CGPoint,
	velocityA		: CGPoint,
	refrectionRateA		: CGFloat,
	massB			: CGFloat,
	positionB		: CGPoint,
	velocityB		: CGPoint,
	refrectionRateB		: CGFloat
	) -> (CGPoint, CGPoint) // Velocity of object A and B
*/
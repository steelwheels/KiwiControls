//
//  UTIntersect.swift
//  KCGraphics
//
//  Created by Tomoo Hamada on 2016/05/07.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Cocoa
import KCGraphics
import KCConsoleView
import CoreGraphics

public class UTCollision
{
	private var mConsole: KCConsole
	
	public init(console: KCConsole){
		mConsole = console
	}
	
	public func executeTest() -> Bool {
		let speedA = CGPointMake( 1.0,  1.0)
		let speedB = CGPointMake(-1.0, -1.0)

		let result0 = testIntersect(true,  deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), speedA: speedA,
		                                                   startB: CGPointMake(  1.0,  1.0), speedB: speedB)
		let result1 = testIntersect(false, deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), speedA: speedA,
								   startB: CGPointMake( 10.0, 10.0), speedB: speedB)
		let result2 = testIntersect(true,  deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), speedA: speedA,
		                                                   startB: CGPointMake(  0.0,  0.0), speedB: speedB)
		return result0 && result1 && result2
	}
	
	private func testIntersect(expect:Bool, deltaTime:CGFloat, startA:CGPoint, speedA:CGPoint, startB:CGPoint, speedB:CGPoint) -> Bool
	{
		mConsole.print(string: "[Test Collision]\n")
		
		let radiusA = CGFloat(0.1)
		let radiusB = CGFloat(0.1)

		mConsole.print(string: " A: start:\(startA.description), speed:\(speedA.description)\n")
		mConsole.print(string: " B: start:\(startB.description), speed:\(speedB.description)")
		
		let (hassect, secttime, sectpoint) = KCIntersect2.calculateCollisionPosition(
			deltaTime,
			radiusA: radiusA,
			startA:  startA,
			speedA:	 speedA,
			radiusB: radiusB,
			startB:  startB,
			speedB:	 speedB
		)
		if hassect {
			let sectdesc = sectpoint.description
			mConsole.print(string: " -> Has collision: time:\(secttime), point:\(sectdesc)\n")
		} else {
			mConsole.print(string: " -> Has no collision\n")
		}
		return hassect == expect
	}
}


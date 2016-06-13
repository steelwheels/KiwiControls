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
		let velocityA = KCVelocity(x: 1.0, y: 1.0)
		let velocityB = KCVelocity(x:-1.0, y:-1.0)

		let result0 = testIntersect(true,  deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), velocityA: velocityA,
		                                                   startB: CGPointMake(  1.0,  1.0), velocityB: velocityB)
		let result1 = testIntersect(false, deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), velocityA: velocityA,
								   startB: CGPointMake( 10.0, 10.0), velocityB: velocityB)
		let result2 = testIntersect(true,  deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), velocityA: velocityA,
		                                                   startB: CGPointMake(  0.0,  0.0), velocityB: velocityB)
		return result0 && result1 && result2
	}
	
	private func testIntersect(expect:Bool, deltaTime:CGFloat, startA:CGPoint, velocityA:KCVelocity, startB:CGPoint, velocityB:KCVelocity) -> Bool
	{
		mConsole.print(string: "[Test Collision]\n")
		
		let radiusA = CGFloat(0.1)
		let radiusB = CGFloat(0.1)

		mConsole.print(string: " A: start:\(startA.description), speed:\(velocityA.longDescription)\n")
		mConsole.print(string: " B: start:\(startB.description), speed:\(velocityB.longDescription)")
		
		let (hassect, secttime, sectpoint) = KCIntersect2.calculateCollisionPosition(
			deltaTime,
			radiusA:	radiusA,
			startA:		startA,
			velocityA:	velocityA,
			radiusB:	radiusB,
			startB:		startB,
			velocityB:	velocityB
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


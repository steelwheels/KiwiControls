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
import Canary
import CoreGraphics

public class UTCollision
{
	private var mConsole: KCConsole
	
	public init(console: KCConsole){
		mConsole = console
	}
	
	public func executeTest() -> Bool {
		let result0 = collisionCircleAndLine()
		let result1 = collisionCircleAndCircle()
		
		if result0 && result1 {
			mConsole.print(string: "[RESULT] OK\n")
			return true
		} else {
			mConsole.print(string: "[RESULT] Error\n")
			return false
		}
	}
	
	private func collisionCircleAndLine() -> Bool {
		
		let result0 = testCollisionCircleAndLine(true,
		                                         deltaTime:	10.0,
		                                         startA:	CGPointMake(0.0, 0.0),
		                                         velocityA:	CNVelocity(x: 1.0, y:0.0),
		                                         startB:	CGPointMake(1.0, -1.0),
		                                         endB:		CGPointMake(1.0,  1.0))
		let result1 = testCollisionCircleAndLine(true,
		                                         deltaTime:	10.0,
		                                         startA:	CGPointMake(0.0, 0.0),
		                                         velocityA:	CNVelocity(x: 1.0, y:0.5),
		                                         startB:	CGPointMake( 0.0,  1.0),
		                                         endB:		CGPointMake(10.0,  1.0))
		let result2 = testCollisionCircleAndLine(false,
		                                         deltaTime:	10.0,
		                                         startA:	CGPointMake(0.0, 0.5),
		                                         velocityA:	CNVelocity(x: 1.0, y:0.5),
		                                         startB:	CGPointMake( 0.0,  0.0),
		                                         endB:		CGPointMake(10.0,  0.0))
		return result0 && result1 && result2
	}
	
	private func testCollisionCircleAndLine(expect:Bool, deltaTime:CGFloat, startA:CGPoint, velocityA:CNVelocity, startB:CGPoint, endB:CGPoint) -> Bool
	{
		let radius = CGFloat(0.1)
		
		mConsole.print(string: "[Test Collision Circule and Line]\n")
		
		mConsole.print(string:	  "deltaTime:\(deltaTime) "
					+ "startA:\(startA.description) "
					+ "velocityA: \(velocityA.longDescription) "
					+ "startB:\(startB.description) "
					+ "endB:\(endB.description) => "
					)
		
		let (hascollision, coltime, colpos) = KCIntersect2.detectCollisionCircleAndLine(deltaTime,
		                                                                                radiusA: radius,
		                                                                                startA:startA,
		                                                                                velocityA: velocityA,
		                                                                                startB: startB,
		                                                                                endB: endB)
		if(hascollision){
			mConsole.print(string: " -> Collision detect at \(colpos.description), \(coltime) -> ")
		} else {
			if expect {
				mConsole.print(string: " -> Has no collision")
			} else {
				mConsole.print(string: " -> Has no collision")
			}
		}
		if hascollision == expect {
			mConsole.print(string: " OK\n")
			return true
		} else {
			mConsole.print(string: " NG\n")
			return false
		}
	}
	
	private func collisionCircleAndCircle() -> Bool {
		let velocityA = CNVelocity(x: 1.0, y: 1.0)
		let velocityB = CNVelocity(x:-1.0, y:-1.0)

		let result0 = testCollisionCircleAndCircle(true,  deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), velocityA: velocityA,
		                                                   startB: CGPointMake(  1.0,  1.0), velocityB: velocityB)
		let result1 = testCollisionCircleAndCircle(false, deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), velocityA: velocityA,
								   startB: CGPointMake( 10.0, 10.0), velocityB: velocityB)
		let result2 = testCollisionCircleAndCircle(true,  deltaTime: 1.0, startA: CGPointMake(  0.0,  0.0), velocityA: velocityA,
		                                                   startB: CGPointMake(  0.0,  0.0), velocityB: velocityB)
		return result0 && result1 && result2
	}
	
	private func testCollisionCircleAndCircle(expect:Bool, deltaTime:CGFloat, startA:CGPoint, velocityA:CNVelocity, startB:CGPoint, velocityB:CNVelocity) -> Bool
	{
		mConsole.print(string: "[Test Collision Circule and Circle]\n")
		
		let radiusA = CGFloat(0.1)
		let radiusB = CGFloat(0.1)

		mConsole.print(string: " A: start:\(startA.description), speed:\(velocityA.longDescription)\n")
		mConsole.print(string: " B: start:\(startB.description), speed:\(velocityB.longDescription)")
		
		let (hassect, secttime, sectpoint) = KCIntersect2.detectCollisionCircleAndCircle(
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


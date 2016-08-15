//
//  UTIntersect.swift
//  KCGraphics
//
//  Created by Tomoo Hamada on 2016/05/07.
//  Copyright © 2016年 Steel Wheels Project. All rights reserved.
//

import Canary
import KCGraphics

public func UTCollisionTest() -> Bool
{
	let result0 = collisionCircleAndLine()
	let result1 = collisionCircleAndCircle()

	if result0 && result1 {
		print("[RESULT] OK\n")
		return true
	} else {
		print("[RESULT] Error\n")
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

	print("[Test Collision Circule and Line]\n")

	print("deltaTime:\(deltaTime) "
		+ "startA:\(startA.description) "
		+ "velocityA: \(velocityA.longDescription) "
		+ "startB:\(startB.description) "
		+ "endB:\(endB.description) => "
	)

	let lineB = KCLine(fromPoint: startB, toPoint: endB)
	let (hascollision, coltime, colpos) = KCIntersect.detectCollisionCircleAndLine(
		deltaTime: deltaTime,
		radiusA: radius,
		startA:startA,
		velocityA: velocityA,
		lineB: lineB)

	if(hascollision){
		print(" -> Collision detect at \(colpos.description), \(coltime) -> ")
	} else {
		if expect {
			print(" -> Has no collision")
		} else {
			print(" -> Has no collision")
		}
	}
	if hascollision == expect {
		print(" OK\n")
		return true
	} else {
		print(" NG\n")
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
	print("[Test Collision Circule and Circle]\n")

	let radiusA = CGFloat(0.1)
	let radiusB = CGFloat(0.1)

	print(" A: start:\(startA.description), speed:\(velocityA.longDescription)\n")
	print(" B: start:\(startB.description), speed:\(velocityB.longDescription)")

	let (hassect, secttime, sectpoint) = KCIntersect.detectCollisionCircleAndCircle(
		deltaTime:	deltaTime,
		radiusA:	radiusA,
		startA:		startA,
		velocity:	velocityA,
		radiusB:	radiusB,
		startB:		startB,
		velocityB:	velocityB
	)
	if hassect {
		let sectdesc = sectpoint.description
		print(" -> Has collision: time:\(secttime), point:\(sectdesc)\n")
	} else {
		print(" -> Has no collision\n")
	}
	return hassect == expect
}


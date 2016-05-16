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
		let line0 = KCLine2(fromPoint: CGPointMake(  0.0, 0.0), toPoint: CGPointMake(10.0, 0.0))
		let line1 = KCLine2(fromPoint: CGPointMake(  0.0, 0.0), toPoint: CGPointMake( 0.0, 10.0))
		let line2 = KCLine2(fromPoint: CGPointMake(  0.0, 0.0), toPoint: CGPointMake(10.0, 10.0))
		
		let line3 = KCLine2(fromPoint: CGPointMake( 10.0, 10.0), toPoint: CGPointMake( 0.0, 0.0))
		let line4 = KCLine2(fromPoint: CGPointMake(  0.0, -5.0), toPoint: CGPointMake(10.0, 5.0))
		//let line5 = KCLine2(fromPoint: CGPointMake( 0.0, 1.0), toPoint: CGPointMake( 1.0, 1.0))
		
		var result = true
		mConsole.print(string: "[Test Collision]\n")
		result = testIntersect(true,  line0: line0, line1: line4) && result
		//result = testIntersect(true,  line0: line2, line1: line3) && result
		result = testIntersect(false, line0: line1, line1: line3) && result
		result = testIntersect(true, line0: line2, line1: line3) && result

		if result {
			mConsole.print(string: "[RESULT] OK\n")
		} else {
			mConsole.print(string: "[RESULT] Error\n")
		}
		return result
	}
	
	private func testIntersect(expect:Bool, line0: KCLine2, line1: KCLine2) -> Bool
	{
		let radiusA = CGFloat(1.0)
		let radiusB = CGFloat(1.0)
		
		let line0desc = line0.description()
		let line1desc = line1.description()
		mConsole.print(string: " from \(line0desc) to \(line1desc):")
		
		let (hassect, secttime, sectpoint) = KCIntersect2.calculateCollisionPosition(radiusA, motionA: line0, radiusB: radiusB, motionB: line1)
		if hassect {
			let sectdesc = sectpoint.description
			mConsole.print(string: " -> Has collision: time:\(secttime), point:\(sectdesc)\n")
		} else {
			mConsole.print(string: " -> Has no collision\n")
		}
		return hassect == expect
	}
}


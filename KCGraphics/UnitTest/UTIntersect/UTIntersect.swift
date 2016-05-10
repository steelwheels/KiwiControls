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

public class UTIntersect
{
	private var mConsole: KCConsole
	
	public init(console: KCConsole){
		mConsole = console
	}
	
	public func executeTest() -> Bool {
		let line0 = KCLine2(fromPoint: CGPointMake( 0.0, 0.0), toPoint: CGPointMake(1.0, 0.0))
		let line1 = KCLine2(fromPoint: CGPointMake( 0.0, 0.0), toPoint: CGPointMake(0.0, 1.0))
		let line2 = KCLine2(fromPoint: CGPointMake( 0.0, 0.0), toPoint: CGPointMake(1.0, 1.0))
		
		let line3 = KCLine2(fromPoint: CGPointMake( 0.0, 1.0), toPoint: CGPointMake(1.0, 0.0))
		let line4 = KCLine2(fromPoint: CGPointMake( 0.0, 0.5), toPoint: CGPointMake(1.0, 0.5))
		let line5 = KCLine2(fromPoint: CGPointMake( 0.0, 1.0), toPoint: CGPointMake(1.0, 1.0))
		
		var result = true
		mConsole.print(string: "[Test Intersect Evaluation]\n")
		result = testIntersect(true, line0: line0, line1: line1) && result
		result = testIntersect(true,  line0: line2, line1: line3) && result
		result = testIntersect(true,  line0: line2, line1: line4) && result
		result = testIntersect(false,  line0: line4, line1: line5) && result
		
		if result {
			mConsole.print(string: "[SUMMARY] OK\n")
		} else {
			mConsole.print(string: "[SUMMARY] Error\n")
		}
		return result
	}
	
	private func testIntersect(expect:Bool, line0: KCLine2, line1: KCLine2) -> Bool
	{
		let line0desc = line0.description()
		let line1desc = line1.description()
		let (hassect, sectpt)  = KCIntersect2.hasIntersection(line0.fromPoint, p0e: line0.toPoint, p1s: line1.fromPoint, p1e: line1.toPoint)
		var result: Bool
		if (hassect && expect) || (!hassect && !expect) {
			result = true
		} else {
			result = false
		}
		let sectstr: String
		if hassect {
			sectstr = sectpt.description
		} else {
			sectstr = "nil"
		}
		mConsole.print(string: " from \(line0desc) to \(line1desc) -> hassect \(hassect), sectpt \(sectstr) -> result \(result)\n")
		return result
	}
}


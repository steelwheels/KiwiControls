/**
* @file		KCIntersect2.swift
* @brief	Define KCIntersect2 class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import CoreGraphics

public class KCIntersect2
{
	/* Reference: http://www5d.biglobe.ne.jp/~tomoya03/shtml/algorithm/Intersection.htm */
	
	public class func hasIntersection(lineA: KCLine2, lineB: KCLine2) -> Bool {
		return hasIntersectionA(lineA.fromPoint, p2: lineA.toPoint, p3: lineB.fromPoint, p4: lineB.toPoint) &&
		       hasIntersectionB(lineA.fromPoint, p2: lineA.toPoint, p3: lineB.fromPoint, p4: lineB.toPoint)
	}
	
	private class func hasIntersectionA(p1: CGPoint, p2:CGPoint, p3: CGPoint, p4:CGPoint) -> Bool {
		var hasintersect: Bool = true
		if (((p1.x - p2.x) * (p3.y - p1.y) + (p1.y - p2.y) * (p1.x - p3.x)) *
		    ((p1.x - p2.x) * (p4.y - p1.y) + (p1.y - p2.y) * (p1.x - p4.x)) > 0) {
			hasintersect = false
		}
		return hasintersect
	}
	
	private class func hasIntersectionB(p1: CGPoint, p2:CGPoint, p3: CGPoint, p4:CGPoint) -> Bool {
		var hasintersect: Bool = false
		if (((p1.x - p2.x) * (p3.y - p1.y) + (p1.y - p2.y) * (p1.x - p3.x)) *
		    ((p1.x - p2.x) * (p4.y - p1.y) + (p1.y - p2.y) * (p1.x - p4.x)) < 0.0){
			if (((p3.x - p4.x) * (p1.y - p3.y) + (p3.y - p4.y) * (p3.x - p1.x)) *
			    ((p3.x - p4.x) * (p2.y - p3.y) + (p3.y - p4.y) * (p3.x - p2.x)) < 0){
				hasintersect = true
			}
		}
		return hasintersect
	}
}


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
	
	/**
	   Get intersection point of line0(p0s and p0e) and line1(p1s, p1e)
	 */
	public class func hasIntersection(p0s:CGPoint, p0e:CGPoint, p1s:CGPoint, p1e:CGPoint) -> (Bool, CGPoint) {
		let denom =   (p0e.x - p0s.x) * (p1e.y - p1s.y) - (p0e.y - p0s.y) * (p1e.x - p1s.x)
		if denom != 0.0 {
			let diff = p1s - p0s
			let dr   = ((p1e.y - p1s.y) * diff.x - (p1e.x - p1s.x) * diff.y) / denom
			//let ds   = ((p0e.y - p0s.y) * diff.x - (p0e.x - p0s.x) * diff.y) / denom
			let intersect = p0s + dr * (p0e - p0s)
			return (true, intersect)
		} else {
			return (false, CGPointZero)
		}
	}
}


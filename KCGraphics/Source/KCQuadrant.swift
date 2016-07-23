/**
 * @file	KCQuadrant.swift
 * @brief	Define KCQuadrant class
 * @par Copyright
 *   Copyright (C) 2016 Steel Wheels Project
 */

import Foundation
import CoreGraphics

public enum KCQuadrant {
	case KCFirstQuadrant
	case KCSecondQuadrant
	case KCThirdQuadrant
	case KCFourthQuadrant
	
	public static func quadrantByAngle(src: CGFloat) -> KCQuadrant {
		let PI = CGFloat(M_PI)
		var quadrant: KCQuadrant
		if PI*0.0<=src && src<PI*0.5 {
			quadrant = KCFirstQuadrant
		} else if PI*0.5<=src && src<PI*1.0 {
			quadrant = KCSecondQuadrant
		} else if PI*1.0<=src && src<PI*1.5 {
			quadrant = KCThirdQuadrant
		} else { // if PI*1.5<=src && src<PI*2.0
			quadrant = KCFourthQuadrant
		}
		return quadrant
	}
}
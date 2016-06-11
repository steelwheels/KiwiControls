/**
* @file		KCIntersect2.swift
* @brief	Define KCIntersect2 class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import CoreGraphics

public class KCIntersect2
{
	/**
	  Get the time and position where the two objects conflict
	  Reference: http://marupeke296.com/COL_3D_No9_GetSphereColliTimeAndPos.html
	 */
	public class func calculateCollisionPosition(
		deltaTime:	CGFloat,
		radiusA:	CGFloat,
		startA:		CGPoint,
		speedA:		CGPoint,
		radiusB:	CGFloat,
		startB:		CGPoint,
		speedB:		CGPoint
	) -> (Bool, CGFloat, CGPoint) // hasSection?, intersect-time, intersect-point
	{
		let C0		= startB - startA
		let A1		= startA + (speedA * deltaTime)
		let B1		= startB + (speedB * deltaTime)
		let C1		= B1 - A1
		let D		= C1 - C0
		
		let rAB		= radiusA + radiusB
		let rABsq	= rAB * rAB
		let P		= lengthSq(point: D)
		
		if P == 0 {
			if lengthSq(point: C0) > rABsq {
				return (false, 0.0, CGPointZero)
			}
			if startA == startB {
				return (true, 0.0, startA)
			}
			let outColPos = startA + (radiusA / rAB) * C0
			return (true, 0.0, outColPos)
		}
		
		if lengthSq(point: C0) < rABsq {
			let outColPos = startA + (radiusA / rAB) * C0
			return (true, 0.0, outColPos)
		}
		
		let Q = C0.dot(D)
		let R = lengthSq(point: C0)
		
		let judge = Q * Q - P * ( R - rAB * rAB );
		if ( judge < 0 ) {
			/* No conflict */
			return (false, 0.0, CGPointZero)
		}
		
		let judge_rt = sqrt(judge)
		var t_plus   = (-Q + judge_rt) / P
		var t_minus  = (-Q - judge_rt) / P
		if t_minus > t_plus {
			/* Swap */
			let tmp = t_minus
			t_minus = t_plus
			t_plus  = tmp
		}
		
		if t_minus<0.0 || 1.0<t_minus {
			return (false, 0.0, CGPointZero)
		}
		
		let outSec = t_minus * deltaTime
		let Atc    = startA + speedA * outSec
		let Btc    = startB + speedB * outSec
		let outPos = Atc + radiusA / rAB * (Btc - Atc)
		
		return (true, outSec, outPos)
	}

	private class func lengthSq(point p: CGPoint) -> CGFloat {
		return (p.x * p.x) + (p.y * p.y)
	}

	/**
	  Calculate updated speed after collision
	  Reference: http://marupeke296.com/COL_MV_No1_HowToCalcVelocity.html
	 */
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
	{
		let totalMass		= massA + massB
		let refrectionRate	= 1 + refrectionRateA * refrectionRateB
		let collisionVector	= (positionB - positionA).normalize()
		let dot			= (velocityA - velocityB).dot(collisionVector)
		let constVector		= refrectionRate * dot / totalMass * collisionVector
		
		let outVelocityA	= -massB * constVector + velocityA
		let outVelocityB	=  massA * constVector + velocityB
		return (outVelocityA, outVelocityB)
	}	
}

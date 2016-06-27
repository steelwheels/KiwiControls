/**
* @file		KCIntersect2.swift
* @brief	Define KCIntersect2 class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import CoreGraphics

public class KCIntersect2
{
	/* http://marupeke296.sakura.ne.jp/COL_3D_No16_MoveShereAndSepLine.html */
	public class func detectCollisionCircleAndLine(
		deltaTime:	CGFloat,
		radiusA:	CGFloat,
		startA:		CGPoint,
		velocityA:	KCVelocity,
		startB:		CGPoint,
		endB:		CGPoint
	) -> (Bool, CGFloat, CGPoint) {
		let IKD_EPSIRON	: CGFloat = 0.00001

		let endA	= startA + velocityA.xAndY * deltaTime
		let E		= endA - startA
		let V		= (endB - startB).normalize()
		let R		= startB - startA
		let A		= (E.dot(V) * V) - E
		let C		= R - R.dot(V) * V

		let alpha	= lengthSq(point: A)
		let beta	= A.dot(C)
		let omega	= lengthSq(point: C) - radiusA * radiusA

		let tmp		= beta * beta - alpha * omega

		if abs(alpha) <= IKD_EPSIRON || tmp < 0 {
			return (false, 0.0, CGPointZero)
		}

		let time = (-sqrt(tmp) - beta) / alpha
		let pos  = startA + time * E
		if (0.0<=time) && (time<=1.0) {
			return (true, time * deltaTime, pos)
		} else {
			return (false, 0.0, CGPointZero)
		}
	}

	private func lengthSq(point p: CGPoint) -> CGFloat {
		return (p.x * p.x) + (p.y * p.y)
	}

	/**
	  Get the time and position where the two objects conflict
	  Reference: http://marupeke296.com/COL_3D_No9_GetSphereColliTimeAndPos.html
	 */
	public class func detectCollisionCircleAndCircle(
		deltaTime:	CGFloat,
		radiusA:	CGFloat,
		startA:		CGPoint,
		velocityA:	KCVelocity,
		radiusB:	CGFloat,
		startB:		CGPoint,
		velocityB:	KCVelocity
	) -> (Bool, CGFloat, CGPoint) // hasSection?, intersect-time, intersect-point
	{
		let C0		= startB - startA
		let A1		= startA + (velocityA.xAndY * deltaTime)
		let B1		= startB + (velocityB.xAndY * deltaTime)
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
		let Atc    = startA + velocityA.xAndY * outSec
		let Btc    = startB + velocityB.xAndY * outSec
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
		velocityA		: KCVelocity,
		refrectionRateA		: CGFloat,
		massB			: CGFloat,
		positionB		: CGPoint,
		velocityB		: KCVelocity,
		refrectionRateB		: CGFloat
	) -> (KCVelocity, KCVelocity) // Velocity of object A and B
	{
		let totalMass		= massA + massB
		let refrectionRate	= 1 + refrectionRateA * refrectionRateB
		let collisionVector	= (positionB - positionA).normalize()
		let dot			= (velocityA.xAndY - velocityB.xAndY).dot(collisionVector)
		let constVector		= refrectionRate * dot / totalMass * collisionVector

		let outVelocityA	= -massB * constVector + velocityA.xAndY
		let outVelocityB	=  massA * constVector + velocityB.xAndY
		let retA		= KCVelocity(x:outVelocityA.x, y:outVelocityA.y)
		let retB		= KCVelocity(x:outVelocityB.x, y:outVelocityB.y)
		return (retA, retB)
	}
}


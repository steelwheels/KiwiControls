/**
* @file		KCIntersect2.swift
* @brief	Define KCIntersect2 class
* @par Copyright
*   Copyright (C) 2016 Steel Wheels Project
*/

import CoreGraphics
import Canary

public class KCIntersect
{
	/* http://marupeke296.sakura.ne.jp/COL_3D_No16_MoveShereAndSepLine.html */
	public class func detectCollisionCircleAndLine(
		deltaTime	dT	: CGFloat,
		radiusA		rA	: CGFloat,
		startA		sA	: CGPoint,
		velocityA	vA	: CNVelocity,
		lineB		lB	: KCLine
	) -> (Bool, CGFloat, CGPoint) {
		let IKD_EPSIRON	: CGFloat = 0.00001

		let endA	= sA + vA.xAndY * dT
		let E		= endA - sA
		let V		= (lB.toPoint - lB.fromPoint).normalize()
		let R		= lB.fromPoint - sA
		let A		= (E.dot(V) * V) - E
		let C		= R - R.dot(V) * V

		let alpha	= lengthSq(point: A)
		let beta	= A.dot(C)
		let omega	= lengthSq(point: C) - rA * rA

		let tmp		= beta * beta - alpha * omega

		if abs(alpha) <= IKD_EPSIRON || tmp < 0 {
			return (false, 0.0, CGPointZero)
		}

		let time = (-sqrt(tmp) - beta) / alpha
		let pos  = sA + time * E
		if (0.0<=time) && (time<=1.0) {
			return (true, time * dT, pos)
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
		deltaTime	dT : CGFloat,
		radiusA		rA : CGFloat,
		startA		sA : CGPoint,
		velocity	vA : CNVelocity,
		radiusB		rB : CGFloat,
		startB		sB : CGPoint,
		velocityB	vB : CNVelocity
	) -> (Bool, CGFloat, CGPoint) // hasSection?, intersect-time, intersect-point
	{
		let C0		= sB - sA
		let A1		= sA + (vA.xAndY * dT)
		let B1		= sB + (vB.xAndY * dT)
		let C1		= B1 - A1
		let D		= C1 - C0

		let rAB		= rA + rB
		let rABsq	= rAB * rAB
		let P		= lengthSq(point: D)

		if P == 0 {
			if lengthSq(point: C0) > rABsq {
				return (false, 0.0, CGPointZero)
			}
			if sA == sB {
				return (true, 0.0, sA)
			}
			let outColPos = sA + (rA / rAB) * C0
			return (true, 0.0, outColPos)
		}

		if lengthSq(point: C0) < rABsq {
			let outColPos = sA + (rA / rAB) * C0
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

		let outSec = t_minus * dT
		let Atc    = sA + vA.xAndY * outSec
		let Btc    = sB + vB.xAndY * outSec
		let outPos = Atc + rA / rAB * (Btc - Atc)

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
		massA			mA  : CGFloat,
		positionA		pA  : CGPoint,
		velocityA		vA  : CNVelocity,
		refrectionRateA		rrA : CGFloat,
		massB			mB  : CGFloat,
		positionB		pB  : CGPoint,
		velocityB		vB  : CNVelocity,
		refrectionRateB		rrB : CGFloat
	) -> (CNVelocity, CNVelocity) // Velocity of object A and B
	{
		let totalMass		= mA + mB
		let refrectionRate	= 1 + rrA * rrB
		let collisionVector	= (pB - pA).normalize()
		let dot			= (vA.xAndY - vB.xAndY).dot(collisionVector)
		let constVector		= refrectionRate * dot / totalMass * collisionVector

		let outVelocityA	= -mB * constVector + vA.xAndY
		let outVelocityB	=  mA * constVector + vB.xAndY
		let retA		= CNVelocity(x:outVelocityA.x, y:outVelocityA.y)
		let retB		= CNVelocity(x:outVelocityB.x, y:outVelocityB.y)
		return (retA, retB)
	}
}


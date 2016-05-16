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
		radiusA			: CGFloat,
		motionA			: KCLine2,
		radiusB			: CGFloat,
		motionB			: KCLine2
	) -> (Bool, CGFloat, CGPoint) {
		let fromVector		= motionB.fromPoint - motionA.fromPoint
		let toVector		= motionB.toPoint   - motionA.toPoint
		let diffVector		= toVector	    - fromVector
		
		let P = diffVector.x * diffVector.x + diffVector.y * diffVector.y
		if P == 0.0 {
			return (false, 0.0, CGPointZero)
		}
		let Q = fromVector.x * diffVector.x + fromVector.y * diffVector.y
		let R = fromVector.x * fromVector.x + fromVector.y * fromVector.y
		
		let radius = radiusA + radiusB

		let judge = Q*Q - P*(R - (radius*radius))
		if judge < 0 {
			return (false, 0.0, CGPointZero)
		}
		
		let t_plus  = (-Q + sqrt(judge)) / P ;
		let t_minus = (-Q - sqrt(judge)) / P ;
		
		if 0.0<=t_minus && t_minus<=1.0 {
			let pos = motionA.fromPoint + t_minus * (motionA.toPoint - motionA.fromPoint)
			return (true, t_minus, pos)
		} else if 0.0<=t_plus && t_plus<=1.0 {
			let pos = motionA.fromPoint + t_plus * (motionA.toPoint - motionA.fromPoint)
			return (true, t_plus, pos)
		} else {
			return (false, 0.0, CGPointZero)
		}
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
